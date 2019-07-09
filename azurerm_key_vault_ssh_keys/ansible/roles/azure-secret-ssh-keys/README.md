# azure-secret-ssh-keys

The role allows to create a SSH key (2048 rsa) both public and private.
Saving the related content within the azure vault secret.
The role also allows you to choose whether to create the secret once or update its value each time

## Role attributes

* azure_secretsshkey_state: present | absent
* azure_secretsshkey_force: yes | no
* azure_secretsshkey_vault_name: "my-vault-name"
* azure_secretsshkey_key: "my-vault-key" > azure secret name for private key
* azure_secretsshkey_key_pub: "my-secret-key-pub" > azure secret name for public key
* azure_secretsshkey_email: "my@email.com"

## Examples

Following is a list of examples demonstrating how to use the role.

### Create and update ssh keys

```yaml
- role: azure-secret-ssh-key
  become: false
  delegate_to: localhost
  vars:
    azure_secretsshkey_state: present
    azure_secretsshkey_force: yes
    azure_secretsshkey_vault_name: "my-vault-name"
    azure_secretsshkey_key: "my-secret-key"
    azure_secretsshkey_key_pub: "my-secret-key-pub"
    azure_secretsshkeyssh_email: my@email.com
```

### Create SSH keys once. Do not update.

```yaml
- role: azure-secret-ssh-key
  become: false
  delegate_to: localhost
  vars:
    azure_secretsshkey_state: present
    azure_secretsshkey_force: no
    azure_secretsshkey_vault_name: "my-vault-name"
    azure_secretsshkey_key: "my-secret-key"
    azure_secretsshkey_key_pub: "my-secret-key-pub"
    azure_secretsshkeyssh_email: my@email.com
```

### Delete SSH keys

```yaml
- role: azure-secret-ssh-key
  become: false
  delegate_to: localhost
  vars:
    azure_secretsshkey_state: absent
    azure_secretsshkey_vault_name: "my-vault-name"
    azure_secretsshkey_key: "my-secret-key"
```
