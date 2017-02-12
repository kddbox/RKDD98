library(Hmisc)
source("./const.R")

load.data <- function(LRN) {
  cup98 <- read.csv(LRN)
  cup98$TARGET_D2 <- cut(cup98$TARGET_D, right = F, breaks = c(0, 0.1,10,15,20,25,30,50, max(cup98$TARGET_D)))
  cup98 <- cup98[, varSet]
  cup98
}

cup98.his <- function(x){
  hist(cup98[,x], main = NULL, xlab = x)
}

view.cup98 <- function(){
  layout(matrix(c(1,2), 1,2))
  idx.num <- which(sapply(cup98, is.numeric))
  sapply(names(idx.num[4:5]), cup98.his)
  layout(matrix(1))
}

#####################run###############
#cup98 <- load.data("./cup98LRN.txt")
view.cup98()