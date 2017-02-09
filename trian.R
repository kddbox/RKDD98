library(party)
source("./const.R")

nRec <- dim(cup98)[1]
train.size <- round(nRec * 0.7)
test.size  <- nRec - train.size
# ctree par
minSplit     <- 1000
minBlucket   <- 400
maxSurrogate <- 4
maxDepth     <- 10

strPar  <- paste(minSplit, minBlucket, maxSurrogate, maxDepth, sep = "-")
loopNum <- 9
cost    <- 0.68
cup98   <- cup98[, c("TARGET_D", varSet2)]


evaluation.tree <- function() {
  pdf(paste("evaluation-tree-", strPar, ".pdf", sep = ""), width = 12, 
      height = 9, paper = "a4r", pointsize = 6)
  # Write head
  cat(date(), "\n")
  cat("trainSize=", train.size, "testSize=", test.size, "\n")
  cat("minSplit=",     minSplit,
      "minBlucket=",   minBlucket,
      "maxSurrogate=", maxSurrogate,
      "maxDepth=",     maxDepth, "\n\n")
  
  allTotalDonation      <- matrix(0, nrow = test.size, ncol = loopNum)
  allAvgDonation        <- matrix(0, nrow = test.size, ncol = loopNum)
  allDonationPercentile <- matrix(0, nrow = test.size, ncol = loopNum)
  
  for(loopCnt in 1:loopNum) {
    cat(date(), ": iter = ", loopCnt, "\n")
    train.idx  <- sample(1:nRec, train.size)
    train.data <- cup98[train.idx,]
    test.data  <- cup98[-train.idx,]
    
    # Train a decision tree
    cup98.tree <- ctree(TARGET_D ~ ., data = train.data, controls = ctree_control(minsplit = minSplit, 
                        minbucket = minBlucket, maxsurrogate = maxSurrogate, maxdepth = maxDepth))
    # Size of ctree
    print(object.size(cup98.tree), units = "auto")
    save(cup98.tree, file = paste("cup98-ctree-", strPar, "-run-", loopCnt, ".rdata", sep = ""))
    
    # Plot
    figTitle <- paste("Tree", loopCnt)
    plot(cup98.tree, main = figTitle, type = "simple",
         ip_args = list(pval = F),
         ep_args = list(digits = 0, abbreviate = T),
         tp_args = list(digits = 2))
    
    # Test
    pred <- predict(cup98.tree, newdata = test.data)
    plot(pred, test.data$TARGET_D)
    print(sum(test.data$TARGET_D[pred > cost] - cost))
    
    s1 <- sort(pred, decreasing = T, method = "quick", index.return = T)
    totalDonation      <- cumsum(test.data$TARGET_D[s1$ix])  # cumlative sum
    avgDonation        <- totalDonation / (1:test.size)
    donationPercentile <- 100 * totalDonation/ sum(test.data$TARGET_D)
    
    allTotalDonation[, loopCnt]      <- totalDonation
    allAvgDonation[, loopCnt]        <- avgDonation
    allDonationPercentile[, loopCnt] <- donationPercentile
    
    plot(totalDonation, type = "l")
    grid()
  }
  
  graphics.off()
  cat(date(), ":Loop completed.\n\n")
  fnlTotalDonation <- rowMeans(allTotalDonation)
  fnlAvgDonation   <- rowMeans(allAvgDonation)
  rm(train.data, test.data, pred)
  
  results        <- data.frame(cbind(allTotalDonation, fnlTotalDonation))
  names(results) <- c(paste("run", 1:loopNum), "Average")
  write.csv(results, paste("evaluation-TotalDonation-", strPar, ".csv", sep = ""))
}