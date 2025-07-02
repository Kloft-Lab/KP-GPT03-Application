# define ui 
ui <- page_sidebar(
  
  ###########################################################################
  ############################# PREAMBLE ####################################
  ###########################################################################
  
  # define title
  title = "ChatGPT-gestützte Medikationsanalyse",
  
  ###########################################################################
  ############################# SIDEBAR #####################################
  ###########################################################################
  
  sidebar = sidebar(
    width = 600,
    card(
      card_header("ChatGPT Einstellungen"),
      selectInput(
        inputId = "model_select",
        label   = "Modell",
        choices = c("gpt-4o", "o3", "o4-mini"),
        selected = "gpt-4o"
      ),
      textInput(
        inputId   = "openai_key",
        label     = "OpenAI API Key",
        value     = "",
        placeholder = "Bitte API-Key eingeben"
      ),
      textAreaInput(
        inputId   = "system_message",
        label     = "System message",
        value     = "",
        placeholder = "Bitte hier System message eingeben …",
        rows      = 5
      ),
      textAreaInput(
        inputId   = "user_message",
        label     = "User message",
        value     = "",
        placeholder = "Bitte hier User message eingeben …",
        rows      = 5
      )
    ),
    card(
      card_header("Analyse"),
      sliderInput(
        inputId = "num_repeats",
        label   = "Anzahl an Wiederholungen",
        min     = 1,
        max     = 100,
        value   = 1,
        step    = 1
      ),
      actionButton(
        inputId = "start_analysis",
        label   = "Analyse starten",
        icon    = icon("play")        # optional: Play-Symbol
      )
    )
  ),
  
  ###########################################################################
  ############################# MAIN BODY ###################################
  ###########################################################################
  
  # create main body
  navset_card_underline(
    nav_panel(
      title = "Prompt",
      fluidRow(
        column(
          width = 12,
          card(
            card_header("Zusammenfassung der Eingaben"),
            tags$dl(
              class = "row",
              tags$dt(class = "col-sm-4", "Modell:"),
              tags$dd(class = "col-sm-8", textOutput("model_selected")),
              
              tags$dt(class = "col-sm-4", "API Key:"),
              tags$dd(class = "col-sm-8", textOutput("api_key_display")),
              
              tags$dt(class = "col-sm-4", "System message:"),
              tags$dd(class = "col-sm-8", verbatimTextOutput("system_message_display")),
              
              tags$dt(class = "col-sm-4", "User message:"),
              tags$dd(class = "col-sm-8", verbatimTextOutput("user_message_display")),
              
              tags$dt(class = "col-sm-4", "Wiederholungen:"),
              tags$dd(class = "col-sm-8", textOutput("repeats_display"))
            )
          )
        )
      )
    )
  )
  
)

# start UI
shinyUI(ui)
