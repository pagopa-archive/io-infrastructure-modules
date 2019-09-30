# azurerm\_application\_insight\_web\_test basic usage:

## Web test terraform representation:

A web test is an entry in the `web_tests` variable, defined as a map of keys, like the one below:

```
web_tests = [
  {
  	name        = <string>
  	url         = <string>
  	headers_xml = <string>
   },
  ...
]
```

## Alerts composition:

Alert definitions require the *name*, *url* and *headers_xml* variables:

```
 variable "name" {
   description = "The name of the web test.
 }
```

```
 variable "url" {
   description = "the url we want to monitor"
 }
```

```	
 variable "headers_xml" {
   description = "A string(s) that contains one or more <Header Key="" Value=" />"
 }
```
