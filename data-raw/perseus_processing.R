## code to prepare `perseus_processing` dataset goes here

#example files
lfq.file <- system.file(
  "extdata",
  "proteinGroups_LFQ.txt",
  package = "peRseus"
)

#example files
tmt.file <- system.file(
  "extdata",
  "proteinGroups_TMT.txt",
  package = "peRseus"
)

mq_raw_lfq <- read.delim(lfq.file, stringsAsFactors = FALSE,colClasses = "character")
mq_raw_TMT <- read.delim(tmt.file, stringsAsFactors = FALSE,colClasses = "character")
#the columns that are used in LFQ are LFQ.intensity
#the columns that are used in TMT are Reporter.intensity.corrected.
perseus_processing<-list(mq_raw_lfq,mq_raw_TMT)

usethis::use_data(mq_raw_lfq,mq_raw_TMT, overwrite = TRUE)
