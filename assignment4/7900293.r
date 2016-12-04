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
