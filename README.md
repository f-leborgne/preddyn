# preddyn

This app currently uses the packages shinyjs, and JM.

Packages that are not installed will be automatically installed from within the app.

For this application to run the package shiny is needed. It can be downloaded from GitHub using the following code:

```{r}
if (!require("devtools"))
  install.packages("devtools")

devtools::install_github("rstudio/shiny")
```
For users behind proxy it could be necessary to properly configure it:
```{r}
if (!require("httr")){
    install.packages("httr")
    library("httr")
 }   
set_config(
  use_proxy(url="...", port=xxxx)
)
```
To download and run this app directly you can use:
```{r}
shiny::runGitHub("preddyn", "f-leborgne")
```
