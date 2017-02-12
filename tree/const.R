varSet <- c(
  # Demongraphic
  "ODATEDW","OSOURCE","STATE","ZIP","PVASTATE","DOB","RECINHSE","MDMAUD","DOMAIN","AGE",
  "HOMEOWNR","CHILD03","CHILD07","CHILD12","CHILD18","NUMCHLD","INCOME","GENDER","WEALTH1","HIT",
  # Donor interests
  "COLLECT1","VETERANS","BIBLE","CATLG","HOMEE","PETS","CDPLAY","STEREO","PCOWNERS","PHOTO",
  "CRAFTS","FISHER","GARDENIN","BOATS","WALKER","KIDSTUFF","CARDS","PLATES",
  # PEP start RFA status
  "PEPSTRFL",
  # Summary var of promotion history
  "CARDPROM","MAXADATE","NUMPROM","CARDPM12","NUMPRM12",
  # summary var of giving history
  "RAMNTALL","NGIFTALL","CARDGIFT","MINRAMNT","MAXRAMNT","LASTGIFT","LASTDATE","FISTDATE","TIMELAG","AVGGIFT",
  # ID & target
  "CONTROLN","TARGET_B","TARGET_D","TARGET_D2","HPHONE_D",
  # RFA (Recency/Frequency/Donation Amount)
  "RFA_2F","RFA_2A","MDMAUD_R","MDMAUD_F","MDMAUD_A",
  # Others
  "CLUSTER2","GEOCODE2"
)

varSet2 <- c(
  "AGE", "AVGGIFT", "CARDGIFT", "CARDPM12", 
  "CARDPROM", "CLUSTER2", "DOMAIN", "GENDER", "GEOCODE2", "HIT",
  "HOMEOWNR", "HPHONE_D", "INCOME", "LASTGIFT", "MAXRAMNT",
  "MDMAUD_F", "MDMAUD_R", "MINRAMNT", "NGIFTALL", "NUMPRM12",
  "PCOWNERS", "PEPSTRFL", "PETS", "RAMNTALL", "RECINHSE",
  "RFA_2A", "RFA_2F", "STATE", "TIMELAG"
)

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