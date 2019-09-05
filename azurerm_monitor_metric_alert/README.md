# azurerm\_monitor\_metric\_alert basic usage:




## Alert terraform representation:

An alert is an entry in the `alerts` variable defined as a map of keys like the one below:

```alerts = [
  {
    azurerm_monitor_action_group_name_suffix               = "01"
    azurerm_monitor_metric_alert_name                      = "io-dev-aks-k8s-01 less then 5 cpu available"
    azurerm_monitor_metric_alert_description               = "Critical: Check io-dev-aks-k8s-01 cpu availability (5 or less)"
    azurerm_monitor_metric_alert_scopes                    = "<redacted>"
    azurerm_monitor_metric_alert_criteria_aggregation      = "Total"
    azurerm_monitor_metric_alert_criteria_metric_name      = "kube_node_status_allocatable_cpu_cores"
    azurerm_monitor_metric_alert_criteria_metric_namespace = "Microsoft.ContainerService/managedClusters"
    azurerm_monitor_metric_alert_criteria_operator         = "LessThanOrEqual"
    azurerm_monitor_metric_alert_criteria_treshold         = "5.0"
  },

```

## Alerts composition:

An alerts definition requires **ALL** the variables defined below

```
 variable "azurerm_monitor_metric_alert_name" {
   description = "The name of the Metric Alert. Changing this forces a new resource to be created."
 }
```
```
 variable "azurerm_monitor_metric_alert_scopes" {
   description = "The resource ID at which the metric riteria should be applied."
 }
```
```	
 variable "azurerm_monitor_metric_alert_description" {
   description = "The description of this Metric Alert."
 }
```
```
 variable "azurerm_monitor_metric_alert_criteria_metric_namespace" {
   description = "One of the metric namespaces to be monitored."
 }
```
```
 variable "azurerm_monitor_metric_alert_criteria_metric_name" {
   description = "One of the metric names to be monitored."
 }
```
```
 variable "azurerm_monitor_metric_alert_criteria_aggregation" {
   description = "The statistic that runs over the metric values. Possible values are Average, Count, Minimum, Maximum and Total."
 }
```
```
 variable "azurerm_monitor_metric_alert_criteria_operator" {
   description = "The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual."
 }
```
```
 variable "azurerm_monitor_metric_alert_criteria_treshold" {
   description = "The criteria threshold value that activates the alert."
 }
```