# parse arguments from bash
args <- commandArgs(TRUE)
tickers <- as.character(read.table(args[1])$V1)
start_date <- args[2]
quantmod_dir <- args[3]

