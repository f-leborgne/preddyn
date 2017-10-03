# preddyn

This app currently uses the packages shinyjs, and JM.

Packages that are not installed will be automatically installed from within the app.

For this application to run the package shiny is needed. It can be downloaded from GitHub using the following code:

```{r}
if (!require("devtools"))
  install.packages("devtools")

devtools::install_github("rstudio/shiny")
```
To download and run this app directly you can use:
```{r}
shiny::runGitHub("preddyn", "f-leborgne")
```
