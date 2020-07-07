#' Automating those initial steps in Perseus
#'
#' Function to clean data output of Maxquant. Can do this data cleaning for two types of experiments, LFQ and TMT.
#'
#' @param mq_raw data frame corresponding to proteingroups.txt
#' @param experiments type of experiment for preporcesing. Options are "LFQ" or "TMT"
#' @param clean_mq  output of the Maxquant cleaning. This has always to be executed.
#' @return object with processed cleaning steps
#' @import dplyr tidyverse magrittr
  library(dplyr)
  library(tidyverse)
  library(magrittr)
  experiment="TMT"

#' @export
  data("mq_raw_TMT", package = "peRseus")

 mq_cleaning<- function(mq_raw,experiment){
  mq_raw %>%
    filter(Potential.contaminant != "+") %>%
    filter(Reverse != "+") %>%
    filter(Only.identified.by.site != "+") %>%
    mutate(type_experiment=experiment)
}
clean_mq<-mq_cleaning(mq_raw_TMT,experiment)

mq_processing<- function(clean_mq,experiment) {

  prelog_mq<- clean_mq
  if (experiment == "LFQ") {
    prelog_mq <- prelog_mq[prelog_mq$type_experiment == "LFQ", ]
    prelog_mq<-prelog_mq  %>%
      mutate_at(vars(starts_with("LFQ.intensity")), as.numeric) %>%
      mutate_at(vars(starts_with("LFQ.intensity")), log2)
  } else {
    prelog_mq <- prelog_mq[prelog_mq$type_experiment == "TMT", ]
    prelog_mq<-prelog_mq  %>%
      mutate_at(vars(starts_with("Reporter.intensity.corrected.")), as.numeric) %>%
      mutate_at(vars(starts_with("Reporter.intensity.corrected.")), log2) %>%
      mutate_each(funs(.-median(.[!is.infinite(.)])), matches('^Reporter.intensity.corrected.'))  #substracting media
  }



  return(prelog_mq)
}
mq_processsed<-mq_processing(clean_mq,experiment)
