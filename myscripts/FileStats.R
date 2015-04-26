# Gather Statistics about the data(Data Summary)

setwd("/Users/manikandanap/Capstone/data/raw")

# 1. Get the size of the file
# 2. No. of lines in file
# 3. Wordcount in file
# 4. No. of letters in the file
# 5. Words per line in the file
# 6. Summarise the details in tabular format

bsz <- format(object.size(readRDS("blogs.rds")),units="Mb")
nsz <- format(object.size(readRDS("news.rds")),units="Mb")
tsz <- format(object.size(readRDS("twitter.rds")),units="Mb")

blc <- length(readRDS("blogs.rds"))
nlc <- length(readRDS("news.rds"))
tlc <- length(readRDS("twitter.rds"))

bwc <- sum(sapply(gregexpr('\\w+',readRDS("blogs.rds")),length)+1)
nwc <- sum(sapply(gregexpr('\\w+',readRDS("news.rds")),length)+1)
twc <- sum(sapply(gregexpr('\\w+',readRDS("twitter.rds")),length)+1)

bbc <-sum(nchar(readRDS("blogs.rds")))
nbc <-sum(nchar(readRDS("news.rds")))
tbc <-sum(nchar(readRDS("twitter.rds")))

bwpl <- bwc/blc
nwpl <- nwc/nlc
twpl <- twc/tlc

require(xtable)

summary_table<-data.frame( fileNames=c('en_US.blogs.txt','en_US.news.txt','en_US.twitter.txt'),Filesize=c(bsz,nsz,tsz),number.of.lines=c(blc,nlc,tlc),number.of.Words=c(bwc,nwc,twc),number.of.letters=c(bbc,nbc,tbc),Words.Per.Line=c(bwpl,nwpl,twpl))

kable( summary_table,caption="Data Summary")

