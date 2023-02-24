library(zoo)
library(xts)
library(forecast)
rm(list=objects())

#C:/Users/antho/Desktop/ENSTA/STA202/Projet

setwd("C:/Users/antho/Desktop/ENSTA/STA202/Projet")
data <- read.table("AirQualityUCI/AirQualityUCI.csv", sep=';', header=T)

plot(data$PT08.S1(CO))