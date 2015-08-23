library(shiny)
library(signal)


data(wav)  # contains wav$rate, wav$sound

inputdata <- c(wav$sound,wav$sound)

# Define server logic required to draw a sound wave and its spectrogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$SpecPlot <- renderPlot({
    
    # Select the section of the soundwave as given in the UI
    startind <- input$startstop[1]
    endind <- input$startstop[2]
    soundwave <- inputdata[startind:endind]
    
    # Calculate the Spectrogrm of the SoundWave using the inputs from the UI
    Fs <- wav$rate
    step <- trunc(as.numeric(input$overlap)*Fs/1000)             # number of spectral slice
    window <- trunc(as.numeric(input$window)*Fs/1000)          # data window
    fftn <- 2^ceiling(log2(abs(window))) # next highest power of 2
    spg <- specgram(soundwave, fftn, Fs, window, window-step)
    S <- abs(spg$S[2:(fftn*4000/Fs),])   # magnitude in range 0<f<=4000 Hz.
    S <- S/max(S)         # normalize magnitude so that max is 0 dB.
    S[S < 10^(-40/10)] <- 10^(-40/10)    # clip below -40 dB.
    S[S > 10^(-3/10)] <- 10^(-3/10)      # clip above -3 dB.
    
    # draw the soundwave and spectrogram 
    par(mfcol = c(1,2))
    p1 = plot((0:(length(soundwave)-1))/Fs/60,soundwave[],type="l",main = "Sound Wave",ylab = "Amplitude",xlab = "Time")
    p2 = image(t(20*log10(S)), axes = FALSE);title(main = "Spectrogram of Sound Wave",ylab = "Frequency",xlab = "Time")
    
  })
})