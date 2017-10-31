load("JM_EJEquesurv_sexeD.RData")	

shinyServer(function(input, output, session) {
	
	rv <- reactiveValues()  
	
	observe({
		if( !isTruthy(input$Dgreffeb) | input$rangGreffe=="" | is.na(input$AgeR_calc) | is.null(input$cardioVasc) | is.null(input$antiClassI) | is.null(input$rejet1an) | is.na(input$creat_3m) | !isTruthy(input$Dsuivi_12m) | is.na(input$creat_12m) ){
			rv$validform <- FALSE
		}else{
			temp <- TRUE
			if(input$ajouter != 0){
				for(i in 1:input$ajouter){
					if(!isTruthy(input[[paste0("Dsuivi_", i)]])){temp <- FALSE}
					if(!isTruthy(input[[paste0("creat_", i)]])){temp <- FALSE}
				}				
			}
			rv$validform <- temp
		}
	})
	
	output$control <- renderText({
		if( rv$validform == FALSE ){
			"<p style='font-size:18px;'>Veuillez compléter tous les champs</p>"
		}
	})
	
	observe({
		if(rv$validform){
			Dsuivi <- input$Dsuivi_12m
			for(i in 1:input$ajouter){
				Dsuivi <- c(Dsuivi, input[[paste0("Dsuivi_", i)]])
			}
			rv$Dsuivi <- Dsuivi
			
			creat <- input$creat_12m
			for(i in 1:input$ajouter){
				creat <- c(creat, input[[paste0("creat_", i)]])
			}
			rv$creat <- creat
		}
	})
	
	observe({
		if(rv$validform & input$ajouter != 0){
			updateSliderInput(session, "slider_graph", value = (input$ajouter+1), min = 1, max = (input$ajouter+1), step = 1)
			show("slider_graph")
		}else{
			hide("slider_graph")
		}
	})
	
	bdd.long <- reactive({
		if(rv$validform){
			data.frame(
				clef = "111", 
				Dsuivi = rv$Dsuivi,
				creat = rv$creat,
				Dgreffeb = input$Dgreffeb, 
				yearGreffe = format(input$Dgreffeb,"%Y"),
				periode2008 = ifelse(as.numeric(format(input$Dgreffeb,"%Y"))<2008,1,0),
				rangGreffe = as.numeric(input$rangGreffe),
				AgeR_calc = input$AgeR_calc,
				cardioVasc = as.numeric(input$cardioVasc),
				antiClassI = as.numeric(input$antiClassI),
				Rejet1an = as.numeric(input$rejet1an),
				creat_3m = input$creat_3m,
				Dsuivi_12mb = input$Dsuivi_12m,
				Evt=0,
				TpsEvtAns_depM12 = as.numeric(max(as.numeric(rv$Dsuivi - input$Dsuivi_12m)/365.25)),
				tps_postM12 = as.numeric((rv$Dsuivi - input$Dsuivi_12m)/365.25),
				AgeR_S = input$AgeR_calc/13.6,		
				creat_3m_S = input$creat_3m/53.4	
			)
		}
	})
	
	#output$base <- renderTable(bdd.long())
	
	#output$base <- DT::renderDataTable(bdd.long(), options=list(pageLength=10, scrollX = TRUE))
	
	
	observeEvent(input$ajouter, {		
		insertUI(
			selector = '#toto',
			where = "beforeBegin",
			ui = fluidPage(
				column(3,div(style="display:inline-grid;margin-top:10px;font-size:14px;font-weight: 700;", paste0("Visite ", input$ajouter+1))),
				column(9,
				div(style="display:inline-block;margin-left:20px;margin-top:-15px;",dateInput(inputId=paste0("Dsuivi_", input$ajouter), label="",  format = "dd/mm/yyyy", value="", width=130)),
				div(style="display:inline-block;margin-left:20px;margin-top:-15px;",numericInput(inputId=paste0("creat_", input$ajouter), label="", value="", min=20, max=2000, width=130))
				)
			)
		);
	})
	
	
	horizon<-5	
	
	output$graph <- renderPlot({
		if(rv$validform){
			if(dim(bdd.long())[1]>=1){
				ND <- bdd.long()
				#survPreds <- vector("list", nrow(ND))
				
				if(input$ajouter != 0){
					ind <- input$slider_graph
				}else{
					ind <- 1
				}
				#for (i in 0:(min(nrow(ND), 5)-1)){
				set.seed(123)
				survPreds <- survfitJM(JM_EJEquesurv_sexeD, newdata=ND[1:ind,], last.time=round(as.numeric(ND[ind,"tps_postM12"]),2), idVar="clef", survTimes=seq(round(as.numeric(ND[ind,"tps_postM12"]),2), round(as.numeric(ND[ind,"tps_postM12"]),2)+horizon,0.33), simulate=T)
				#}
				
				
				
				plot.survfitJM(survPreds, estimator="median", conf.int=TRUE, include.y=TRUE, ylab="", ylab2="", xlab="", main=paste("Visite ", ind))
				
				mtext("log(serum of creatinine)", side=2, line=-1, outer=TRUE)
				mtext("Survival Probability", side=4, line=-1, outer=TRUE)				
			}
		}
	},width = function() {
		min(session$clientData$output_graph_width,500)
	})	

	
})

