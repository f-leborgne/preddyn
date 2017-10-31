# check if necessary packages are installed and install if not
list.of.packages <- c("shiny", "shinyjs", "JM")

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# load packages
lapply(list.of.packages, require, character.only = T)

dateInputRow<-function (inputId, label, format) 
{
    div(style="display:inline-block",id = inputId, 
        tags$label(label, `for` = inputId), 
        tags$input(type = "date", format = format, class="form-inline"))
}

numericInputRow<-function (inputId, label, value, min, max) 
{
    div(style="display:inline-block",
        tags$label(label, `for` = inputId), 
        tags$input(id = inputId, type = "numeric", value = value, min = min, max = max, class="input-small", width=20))
}

# Define UI for application that draws a histogram
shinyUI(fluidPage(	
	useShinyjs(),
	
	fluidPage( # un fuildpage en plus pour centrer le titre
		titlePanel("", "Prédiction dynamiques - DIVAT")
	),
	
	# Sidebar with a slider input for the number of bins
	sidebarLayout(
	
		div( id="sidebar",sidebarPanel(
			width=3,
			dateInput("Dgreffeb", "Date de greffe", format = "dd/mm/yyyy"),
			tags$label(br(),""),
			selectInput("rangGreffe", "Transplantation rank", c("Choose"="",1,2)),
			tags$label(br(),""),
			numericInput("AgeR_calc", "Recipient age at transplantation (year)", "", min=1, max=90),
			tags$label(br(),""),
			tags$label(br(),""),
			radioButtons("cardioVasc", "Antécédents cardio-vasculaires", choices = c("Non"=0, "Oui"=1), selected = character(0), inline = TRUE),
			tags$label(br(),""),
			radioButtons("antiClassI", "Immunisation anti-class I", choices = c("Non"=0, "Oui"=1), selected = NULL, inline = TRUE),
			tags$label(br(),""),
			radioButtons("rejet1an", "Rejet dans la première année", choices = c("Non"=0, "Oui"=1), selected = NULL, inline = TRUE),
			tags$label(br(),""),
			numericInput("creat_3m", "Créatinine à 3 mois (µmol/l)", "", min=20, max=2000)			
		)),  
		mainPanel(
			width=9,
			wellPanel(
				fluidPage(
					tags$head(tags$style(HTML('.form-group {margin:0px;}'))),
					tags$head(tags$style(HTML('.selectize-control {margin-bottom:-5px;}'))),
					column(3,
						div(style="display:inline-grid;", tags$label(br(),HTML("<p style='height:25px;padding-top:10px;'>Visite des 12 mois post-greffe</p>")))
					),
					column(9,
						div(style="display:inline-block;margin-left:20px;",dateInput(inputId="Dsuivi_12m", label="Date", format = "dd/mm/yyyy", width=130)),
						div(style="display:inline-block;margin-left:20px;",numericInput(inputId="creat_12m", label="Créatinine (µmol/l)", value="", min=20, max=2000, width=130))
					)
				),
				div(id="toto", br()),
				actionButton("ajouter", "Ajouter un suivi")
			),
			htmlOutput("control"),
			#DT::dataTableOutput("base"),
			plotOutput("graph",height=500),
			hidden(sliderInput("slider_graph","Visite",min=1,max=4, value=4, ticks=FALSE)),
			br(br())
		)
	)
))
















