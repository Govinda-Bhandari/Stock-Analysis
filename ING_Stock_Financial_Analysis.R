install.packages("quantmod")
install.packages("timeSeries")
install.packages("Quandl")
library(plotly)
library(Quandl)
library(quantmod)
library(timeSeries)

## Extracting Data from Quandl API 
ING<-Quandl("WSE/INGBSK", api_key="FQwxjV23psbrzghi1Qbg",start_date="2016-01-01",end_date="2021-01-22",adjust=TRUE)
View(ING)
class(ING)
## Cleaing and Transforming Data
ING.WSE<- as.xts(zoo(ING[,2:8],order.by = as.Date(ING$Date)))
class(ING.WSE)                    
ING.Monthly<-to.period(ING.WSE,period = "months")
View(ING.Monthly)
barChart(ING.Monthly,type = "bars",show.grid = TRUE, name = "WSE ING BANK",bar.type = "ohlc",theme = "black",up.col="green",dn.col="red")
##Candle Chart
chartSeries(ING.Monthly,name = "ING Bank Stock Price WSE",type = "candlestick",time.scale = NULL)
## Candle stick with different chart color and background
chartSeries(ING.Monthly,name = "ING Bank Stock Price WSE",type = "candlestick",time.scale = NULL,theme ="white",up.col="green",dn.col="red")
## Technical Analysis
## Simple Moving Average
addSMA(n=5,col="green")
addSMA(n=8,col="blue")
addSMA(n=13,col = "red")
## Relative Signal Strength
addRSI()
## Moving Average Convergance Divergence with different Argument
addMACD(fast = 12,slow = 26,signal = 9,type = "EMA")
addBBands(n=20,sd=2,maType = "SMA")

candleChart(ING.WSE, up.col = "green", dn.col = "red", theme = "white", subset = "2020-01-29/")

ING_sma_20 <- SMA(
  Cl(ING.WSE),  
  n = 20    
)

ING_sma_50 <- SMA(
  Cl(ING.WSE),
  n = 50
)

ING_sma_200 <- SMA(
  Cl(ING.WSE),
  n = 200
)
zoomChart("2020") 
addTA(ING_sma_20, on = 1, col = "red") 
addTA(ING_sma_50, on = 1, col = "blue")
addTA(ING_sma_200, on = 1, col = "green")

ING_trade <- ING.WSE
ING_trade$`20d` <- ING_sma_20
ING_trade$`50d` <- ING_sma_50
# sigcomaprision() function required quantstart packages. some packages cant download automatically,downloading and installing manually required.
install.packages("devtools")
require(devtools)
install_github("braverock/FinancialInstrument")
install_github("joshuaulrich/xts")
install_github("braverock/blotter")
install_github("braverock/quantstrat")
install_github("braverock/PerformanceAnalytics")

regime_val <- sigComparison("", data = ING_trade,
                            columns = c("20d", "50d"), relationship = "gt") -
              sigComparison("", data = ING_trade,
                            columns = c("20d", "50d"), relationship = "lt")
plot(regime_val["2020"], main = "Regime", ylim = c(-2, 2))

plot(regime_val, main = "Regime", ylim = c(-2, 2))
candleChart(ING.WSE, up.col = "green", dn.col = "red", theme = "white", subset = "2020-01-29")
addTA(regime_val, col = "blue", yrange = c(-2, 2))
addLines(h = 0, col = "black", on = 3)
addSMA(n = c(20, 50), on = 1, col = c("red", "blue"))
zoomChart("2020")
table(as.vector(regime_val))
signal <- diff(regime_val) / 2
plot(signal, main = "Signal", ylim = c(-2, 2))
table(signal)
Cl(ING.WSE)[which(signal == 1)]
Cl(ING.WSE)[signal == -1]
as.vector(Cl(ING.WSE)[signal == 1])[-1] - Cl(ING.WSE)[signal == -1][-table(signal)[["1"]]]
candleChart(ING.WSE, up.col = "green", dn.col = "red", theme = "white")
addTA(regime_val, col = "blue", yrange = c(-2, 2))
addLines(h = 0, col = "black", on = 3)
addSMA(n = c(20, 50), on = 1, col = c("red", "blue"))
zoomChart("2020-07/2021-01")

