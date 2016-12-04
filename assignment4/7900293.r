sellsPerYear <- list() # global list of matrices

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

  sellsPerYear <<- unlist(list(sellsPerYear, list(sellsMatrix)), recursive=FALSE)
}


# Part 2
initStocks = matrix(
  c(10, 10, 10, 10, 10, 30, 50, 50, 30, 10, 10, 10,
    40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40,
    40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 400, 400
  ),
  nrow  = 3,
  ncol  = 12,
  byrow = TRUE
)

printOrder = function(m) {
  return(paste("->", m[1], "AC\n ->", m[2], "appliances\n ->", m[3], "toys"))
}

checkStocks = function(yearIndex, stocks, isVerbose = FALSE) {
  if (yearIndex <= 0 || yearIndex > length(sellsPerYear)) {
    return(NULL)
  }

  sellsThisYear = sellsPerYear[[yearIndex]]
  monthBucket = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
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

    stocks[, (i %% 12) + 1] <- ifelse(nextOrder == 0, monthDiff, nextMonthStocks) # if current stock bigger then next month, update next month stock

    if (isVerbose) {
      cat(monthBucket[i], "\n---------------\n", printOrder(nextOrder), "\n\n") # print order
    }
  }

  # cat("\n\n")
  # write.matrix(stocks)
  return(stocks)
}


# Part 3
