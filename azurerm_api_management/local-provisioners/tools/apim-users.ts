import apiManagementClient from "azure-arm-apimanagement";
import * as t from "io-ts";
import * as winston from "winston";
import yargs = require("yargs");

import { getObjectFromJson } from "../lib/config";
import { login } from "../lib/login";

const TaskParams = t.intersection([
  t.interface({
    apim: t.string,
    email: t.string,
    "resource-group": t.string
  }),
  t.partial({
    "add-groups": t.string,
    "remove-groups": t.string
  })
]);

type TaskParams = t.TypeOf<typeof TaskParams>;

const parseGroupsList = (p: string) => p.split(",").map(_ => _.trim());

export const run = async (params: TaskParams) => {
  winston.info(
    `resource-group=${params["resource-group"]}|apim=${params.apim}|email=${
      params.email
    }`
  );

  const loginCreds = await login();
  const apiClient = new apiManagementClient(
    loginCreds.creds,
    loginCreds.subscriptionId
  );

  winston.debug("Fetching user info...");

  const users = await apiClient.user.listByService(
    params["resource-group"],
    params.apim,
    {
      filter: `email eq '${params.email}'`
    }
  );

  if (users.length === 0) {
    throw Error("No users found");
  }

  winston.info(JSON.stringify(users));

  const user = users[0];

  const uid = user.name;

  if (uid === undefined) {
    throw Error("FATAL! Cannot read user ID");
  }

  winston.debug("Fetching current user groups...");

  const userGroups = await apiClient.userGroup.list(
    params["resource-group"],
    params.apim,
    uid
  );

  winston.info(
    `Current groups: ${userGroups.map(_ => _.displayName).join(",")}`
  );

  const addGroupsParam = params["add-groups"];
  if (addGroupsParam !== undefined) {
    const gs = parseGroupsList(addGroupsParam);
    await Promise.all(
      gs.map(async g => {
        winston.info(`Adding user to group ${g}`);
        await apiClient.groupUser.create(
          params["resource-group"],
          params.apim,
          // group id is group name in lower case
          g.toLowerCase(),
          uid
        );
      })
    );
  }

  const removeGroupsParam = params["remove-groups"];
  if (removeGroupsParam !== undefined) {
    const gs = parseGroupsList(removeGroupsParam);
    await Promise.all(
      gs.map(async g => {
        winston.info(`Removing user from group ${g}`);
        await apiClient.groupUser.deleteMethod(
          params["resource-group"],
          params.apim,
          // group id is group name in lower case
          g.toLowerCase(),
          uid
        );
      })
    );
  }
};

const argv = yargs
  .option("resource-group", {
    string: true
  })
  .option("apim", {
    string: true
  })
  .option("email", {
    string: true
  })
  .option("add-groups", {
    string: true
  })
  .option("remove-groups", {
    string: true
  })
  .help().argv;

(async () => getObjectFromJson(TaskParams, argv))()
  .then(e =>
    e.map(run).mapLeft(err => {
      throw err;
    })
  )
  .then(() => winston.info("Completed"))
  .catch((e: Error) => winston.error(e.message));
