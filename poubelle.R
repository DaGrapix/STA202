

```{r,include=TRUE}
#Normalization
X= (ts_PT08.CO - mean(air_data$PT08.S1.CO.))/sd(ts_PT08.CO)
plot(X)
plot(ts_PT08.CO)
dygraph(X) %>% dyRangeSelector()


# Trend modelisation using a quadratic function
t <- c(1:length(Date_air))
reg<-lm(X~t+I(t^2))
y.chap.lm <- xts(reg$fitted, order.by = Date_air)
lines(y.chap.lm, col='red')
plot(X-y.chap.lm)  


# Trend modelisation using Moving average trend
l <- 24
mb <- stats::filter(X, filter=array(1/l,dim=l),
                    method = c("convolution"),
                    sides = 2, circular = F)
mb <- xts(mb,order.by=Date_air)
X.detrend <- X - mb
plot(X)
lines(mb, col='red')
lines(X.detrend, col='green')
dygraph(X.detrend) %>% dyRangeSelector()


#Seasonality
### A FAIRE ###



# TEST Auto decompose
Acf(X, lag.max=1000)
X.diff <- diff(X, lag = 24, difference=2)
Acf(X.diff, lag.max=1000)
X.decompose <- decompose(ts(X.diff, frequency=24))
plot(X.decompose$x)
lines(X.decompose$trend, col='red')
plot(X.decompose$seasonal, col='blue')
plot(X.decompose$random)
Acf(X.decompose$random)


# modélisation du résidu
residual = X.decompose$random
residual <- apply(residual, 2, 
                  function(x) replace(x, is.na(x), mean(x, na.rm = TRUE)))

Acf(residual, lag.max=50)
Pacf(residual, lag.max=50)

residual.model <- auto.arima(residual)
summary(residual.model)
plot(residual.model$residuals)

adf.test(residual.model$residuals)
shapiro.test(residual.model$residuals[c(1:5000)])
```