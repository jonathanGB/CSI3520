# Part 1
generateACYear = function() {
  avgPerMonth = c(5, 5, 5, 5, 5, 30, 45, 50, 30, 5, 5, 5)

  return (rpois(1:12, avgPerMonth))
}

generateAppYear = function() {
  uniformDistr = as.integer(runif(1:12, 10, 40))

  return(rpois(1:12, uniformDistr))
}

generateToyYear = function() {
  normalDistr = as.integer(rnorm(1:12, 30, 9))
  normalToPoissonDistr = rpois(1:12, normalDistr)
  normalToPoissonDistr[11] = normalToPoissonDistr[11] + as.integer(runif(1, 100, 200))
  normalToPoissonDistr[12] = normalToPoissonDistr[12] + as.integer(runif(1, 300, 400))

  return(normalToPoissonDistr)
}

generateNewYear = function() {
  sells = c(generateACYear(), generateAppYear(), generateToyYear())
  sellsMatrix = matrix(
    sells,
    nrow  = 3,
    ncol  = 12,
    byrow = TRUE
  )

  return(sellsMatrix)
}


# Part 2
initStocks = matrix(
  c(
    10, 10, 10, 10, 10, 30, 50, 50, 30, 10, 10, 10,
    40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40,
    40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 400, 400
  ),
  nrow  = 3,
  ncol  = 12,
  byrow = TRUE
)
monthBucket = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

printOrder = function(m) {
  return(paste("->", m[1], "AC\n ->", m[2], "appliances\n ->", m[3], "toys"))
}

checkStocks = function(sellsPerYear, ind, stocks, isVerbose = FALSE) {
  sellsThisYear = sellsPerYear[[ind]]
  ordersList = list()
  # write.matrix(stocks)
  # cat("\n")
  # write.matrix(sellsThisYear)
  # cat("\n\n\n")

  for (i in 1:12) {
    monthStocks     <- stocks[, i]
    nextMonthStocks <- stocks[, (i %% 12) + 1]
    monthSells      <- sellsThisYear[, i]
    monthDiff       <- ifelse(monthStocks - monthSells < 0, 0, monthStocks - monthSells) # doesn't allow more sells than current stock
    nextOrder       <- ifelse(nextMonthStocks - monthDiff < 0, 0, nextMonthStocks - monthDiff) # don't refill stocks if current stock is bigger than next month
    ordersList      <- unlist(list(ordersList, list(nextOrder)), recursive = FALSE)


    stocks[, (i %% 12) + 1] <- ifelse(nextOrder == 0, monthDiff, nextMonthStocks) # if current stock bigger then next month, update next month stock

    if (isVerbose) {
      cat(monthBucket[i], "\n---------------\n", printOrder(nextOrder), "\n\n") # print order
    }
  }

  # cat("\n\n")
  # write.matrix(stocks)
  return(list(stocks, ordersList))
}

runPart2 = function() {
  sells <- list(generateNewYear())
  dummy <- checkStocks(sells, 1, initStocks, TRUE)
}


# Part 3
runPart3 = function(isVerbose = FALSE) {
  sellsPerYear = list()
  for (i in 1:3) {
    sellsPerYear <- unlist(list(sellsPerYear, list(generateNewYear())), recursive=FALSE)
  }

  currStocks = initStocks
  ordersPerYear = list()
  for (i in 1:3) {
    data <- checkStocks(sellsPerYear, i, currStocks, isVerbose)
    currStocks <- data[[1]]
    ordersPerYear <- unlist(list(ordersPerYear, list(data[[2]])), recursive=FALSE)
  }

  avgOrderAC = c()
  avgOrderApp = c()
  avgOrderToy = c()

  for (i in 1:12) {
    avgOrderAC <- c(avgOrderAC, ((ordersPerYear[[1]][[i]][1] + ordersPerYear[[2]][[i]][1] + ordersPerYear[[3]][[i]][1]) / 3))
    avgOrderApp <- c(avgOrderApp, ((ordersPerYear[[1]][[i]][2] + ordersPerYear[[2]][[i]][2] + ordersPerYear[[3]][[i]][2]) / 3))
    avgOrderToy <- c(avgOrderToy, ((ordersPerYear[[1]][[i]][3] + ordersPerYear[[2]][[i]][3] + ordersPerYear[[3]][[i]][3]) / 3))
  }

  hist(avgOrderToy, freq=FALSE, main="histogramme toy", col="coral")
  lines(density(avgOrderToy))

  dev.new()
  hist(avgOrderAC, freq=FALSE, main="histogramme AC", col="aliceblue")
  lines(density(avgOrderAC))

  dev.new()
  hist(avgOrderApp, freq=FALSE, main="histogramme Appliances", col="aquamarine")
  lines(density(avgOrderApp))

  # script

  print(sellsPerYear)
  maxVal = max(sellsPerYear[[1]][2,])
  maxMonth = monthBucket[which(maxVal == sellsPerYear[[1]][2,])]

  toy50Ind = which(sellsPerYear[[2]][3,] > 50)
  print(toy50Ind)
  toy50Month = monthBucket[toy50Ind]
  toy50Sum = sum(sellsPerYear[[2]][3,toy50Ind])

  print("Final Script")
  print("------------")
  cat("Most sold ACs in year 1 is", maxVal, "in", maxMonth, "\n")
  cat("Months with over 50 toys sold are", toy50Month, "with a sum during these months of", toy50Sum, "\n")

  allACs <- rbind(sellsPerYear[[3]][1,], sellsPerYear[[3]][1,] - rowMeans(cbind(sellsPerYear[[3]][1,], sellsPerYear[[3]][2,], sellsPerYear[[3]][3,]), na.rm=TRUE))
  dev.new()
  barplot(allACs, beside=TRUE, main="AC compared to average")
}
