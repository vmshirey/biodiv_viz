#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(dplyr)
library(shiny)
library(googleVis)

# load data & aggregate for counts
O_fasciatus_dat <- read.csv("occurrence.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)

dat <- aggregate(O_fasciatus_dat$dwc.individualCount~O_fasciatus_dat$idigbio.eventDate, FUN=length, data=O_fasciatus_dat)
dat <- na.omit(dat)
dat$`O_fasciatus_dat$idigbio.eventDate`<- strptime(x=as.character(dat$`O_fasciatus_dat$idigbio.eventDate`),
                                                   format = "%Y-%m-%dT%H:%M")
dat <- dat[!is.na(dat$`O_fasciatus_dat$idigbio.eventDate`),]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$Plot <- renderGvis({
    
    # generate GVis Calendar for occurrence records
    Cal <- gvisCalendar(dat, datevar="O_fasciatus_dat$idigbio.eventDate", numvar="O_fasciatus_dat$dwc.individualCount", options=list(width=1000, height=24000))
    
  })
  
})
