source("./const.R")

cup98.chisqTest <- function(name) {
  tb <- table(cup98pos[,name], cup98pos$TARGET_D2)
  plot(tb, main = name, las=1)
  print(name)
  print(chisq.test(tb))
}