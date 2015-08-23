library(shiny)
library(signal)

data(wav)  # contains wav$rate, wav$sound

inputdata <- c(wav$sound,wav$sound)

# Define UI for application that draws a sound wave and its spectrogram
shinyUI(fluidPage(

  title = "Spectrogram Explorer",
  
  br(),
  
  h2("Spectrogram Explorer"),
  
  br(),
  
  h5("This Application allows a user to explore a spectrogram plot of some demo data from the signal package."),
  h5("A spectrogram basically displays the data in a different way by showing how much of each frequency is in the signal."),
  h5("The color of the spectrogram has a gradation - very low levels of a frequency shown by WHITE/YELLOW, and very high levels of frequency shown by DARK RED."),
  h5("Every dataset has an optimal view of a spectrogram. Play with the values below to find parameters that make intuitive sense visually"),
  h5("It might take some time for the spectrogram to load"),
  
  plotOutput("SpecPlot"),
  
  hr(),
  
  fluidRow(
    column(3,
           
           sliderInput('startstop', label = h3('Data Size'), 
                       min=1, max=length(inputdata), value=c(10000,length(inputdata)), 
                       step=1000),
           h5("Changing the size of the value will plot more or less of the data - treat this as a way to zoom in and out of the data")
           
    ),
    
    column(4, offset = 1,
          
           sliderInput('window', label = h3('Spectrogram Window'), min=10, max=100, value= 40,step=10),
           h5("Changing this will affect the number of columns in the spectrogram ")
    ),
    
    column(4, 
           
           sliderInput('overlap', label = h3('Spectrogram Overlap'), min=5, max=10, value=25,step=5),
           h5("Changing this will affect the smoothness of the spectrogram")
    )
  )
))