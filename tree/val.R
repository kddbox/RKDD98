source("./const.R")

cup98val <- read.csv("./cup98VAL.txt")
cup98val <- cup98val[, c("CONTROLN", varSet2)]

train.names <- names(cup98)
score.names <- names(cup98val)

idx <- which(!(train.names %in% score.names))
score.data <- cup98val
vars <- intersect(train.names, score.names)

for(i in 1:length(vars)) {
  varName <- vars[i]
  train.levels <- levels(cup98[, varName])
  score.levels <- levels(score.data[, varName])
  
  if(is.factor(cup98[, varName]) & setequal(train.levels, score.levels) == F) {
    cat("WARINING: New value found in score, and they will be change to NA!\n")
    cat(varName, "\n")
    
    score.data[, varName] <- factor(score.data[, varName], levels = train.levels)
  }
}

rm(cup98val)

# Pred

load("./cup98-ctree-1000-400-4-10-run-7.rdata")
pred <- predict(cup98.tree, newdata = score.data)
pred <- round(pred, digits = 3)
pred.result <- data.frame(score.data$CONTROLN, pred)
names(pred.result) <- c("CONTROLN", "pred9")

valTarget <- read.csv("./valtargt.txt")
merged <- merge(pred.result, valTarget, by = "CONTROLN")
print(sum(valTarget$TARGET_D - cost))

idx <- (merged$pred > cost)
print(sum(merged$TARGET_D[idx] - cost))

# rank customers
merged.order <- merged[order(merged$pred, decreasing = T), ]
x <- 100 * (1:nrow(merged.order)) / nrow(merged.order)
y <- cumsum(merged.order$TARGET_D) - cost * (1:nrow(valTarget))
idx.pos <- c(seq(1, length(x), by = 10), length(x))

plot(x[idx.pos], y[idx.pos], type = "l", xlab = "Contact precentile(%)",
     ylab = "Amount of donation")
grid()