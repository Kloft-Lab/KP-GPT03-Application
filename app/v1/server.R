# define server
server <- function(input, output, session) {
  
  #############################################################################
  ######################### PREAMBLE ##########################################
  #############################################################################
  
  # reactive values to store user input and modal state
  rv <- reactiveValues(
    # baseline protein conc
    xxx = NA 
  )
  
  #############################################################################
  ######################### EVENT LISTENERS ###################################
  #############################################################################
  
  ######################### BUTTONS ###########################################
  
  # start analysis button
  report_path <- observeEvent(input$start_analysis, {
    # Modal anzeigen
    showModal(modalDialog(
      title = "Bitte warten",
      "Analyse läuft…",
      footer = NULL
    ))
    
    # render report
    quarto::quarto_render(
      input = "report.qmd",
      execute_params = list(
        par_list = input |> as.list()
      )
    )
    
    # 3. Warte-Modal entfernen und Ergebnis-Modal zeigen
    removeModal()
    showModal(modalDialog(
      title = "Analyse abgeschlossen",
      tagList(
        p("Der Bericht und die Rohdaten stehen zum Download bereit!"),
        br(), 
        fluidRow(
          column(
            width = 6,
            downloadButton("download_report", "Bericht (.html)", width = "100%")
          ),
          column(
            width = 6,
            downloadButton("download_csv", "Antworten (.csv)", width = "100%")
          )
        )
      ),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
    
  })
  
  # Download-Handler definieren
  output$download_report <- downloadHandler(
    filename = function() "report.html",
    content = function(file) {
      file.copy("report.html", file, overwrite = TRUE)
    }
  )
  
  output$download_csv <- downloadHandler(
    filename = function() "chat_responses.csv",
    content = function(file) {
      file.copy("chat_responses.csv", file, overwrite = TRUE)
    }
  )
  

  #############################################################################
  ######################### OUTPUT RENDERERS ##################################
  #############################################################################

  ######################### TEXT ##############################################
  
  # seleceted model
  output$model_selected <- renderText({ 
    input$model_select 
  })
  
  # For security, mask the API key except last 4 characters
  output$api_key_display <- renderText({
    key <- input$openai_key
    if (nchar(key) > 4) {
      paste0(strrep("*", nchar(key)-4), substr(key, nchar(key)-3, nchar(key)))
    } else {
      key
    }
  })
  
  # system message
  output$system_message_display <- renderText({ 
    input$system_message 
  })
  
  # user message
  output$user_message_display   <- renderText({ 
    input$user_message 
  })
  
  # number of repetitions
  output$repeats_display        <- renderText({ 
    input$num_repeats 
  })

}


#############################################################################
######################### CALL SERVER #######################################
#############################################################################

# call server
shinyServer(server)

