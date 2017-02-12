source("./const.R")

results <- read.csv("evaluation-TotalDonation-1000-400-4-10.csv")
results[, 2:11] <- results[, 2:11] - cost * (1:test.size)
idx.pos <- c(seq(1, nrow(results), by = 10), nrow(results))
plot(results[idx.pos, 11], type = "l", lty = 1, col = 1, ylim = c(0, 4500),
     xlab ="Number of mails", ylab = "Amount of donation ($)")

for(fCnt in 1:loopNum) {
  lines(results[idx.pos, fCnt + 1], pty = ".", type = "l", lty = 1 + fCnt, col = 1 + fCnt)
}

legend("bottomright", col = 1:(1 + loopNum), lty = 1:(1 + loopNum),
       legend = c("Average", paste("Run", 1:loopNum)))