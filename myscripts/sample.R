# Load the data and sample the corpus by % for Training,Dev Test and Testing

setwd("/Users/manikandanap/Capstone")
lang <- "en_US"
rawdatadir <- "data/raw"
cleandatadir <- "data/clean"
library(R.utils)
#set.seed(12345)

# sample corpus files, save separate files for training, devtest and testing
# percent of total lines used in training, dev.testing and testing stages
# the higher the percentage of data used in training, the higher the accuracy, but
# also the higher the sparsity of data and the memory/time required to process the data

all.train <- c()
all.devtest <- c()
all.test <- c()

for (src in c('blogs', 'news', 'twitter')) {
        txt <- readRDS(sprintf("%s/%s.rds", cleandatadir, src))
        numLines <- length(txt)
        training <- 5
        sampleSize <- ceiling(numLines * training / 100)
#for training set
        sampledIds <- sample(1:length(txt), sampleSize) 
        sampledLines <- txt[sampledIds]
        all.train <- c(all.train, sampledLines)
#save one file with sampled training data from each corpus
        saveRDS(sampledLines, sprintf("%s/%s.train.rds", cleandatadir, src))
# Take the rest and divide them for devtest and testing  data sets 
        txt <- txt[-sampledIds]
        devtest <- 1
        sampleSize <- ceiling(numLines * devtest / 100)
#for dev test set
        sampledIds <- sample(1:length(txt), sampleSize) #for dev test
        sampledLines <- txt[sampledIds]
        all.devtest <- c(all.devtest, sampledLines)
        saveRDS(sampledLines, sprintf("%s/%s.devtest.rds", cleandatadir, src))
#finally for the test set
        txt <- txt[-sampledIds]
        testing <- 1
        sampleSize <- round(numLines * testing / 100)
        if (sampleSize >= length(txt)) {
                sampledLines <- txt
        } else {
                sampledIds <- sample(1:length(txt), sampleSize) # for testing
                sampledLines <- txt[sampledIds]
        }
        all.test <- c(all.test, sampledLines)
        saveRDS(sampledLines, sprintf("%s/%s.test.rds", cleandatadir, src))
}

#save files containing samples from all corpus
saveRDS(all.train, sprintf("%s/all.train.rds", cleandatadir))
saveRDS(all.devtest, sprintf("%s/all.devtest.rds", cleandatadir))
saveRDS(all.test, sprintf("%s/all.test.rds", cleandatadir))


# Alternate way - straighforward allocation of 1000 samples each

#blogs_txt <- readRDS(sprintf("%s/%s.rds", rawdatadir, "blogs"))
#news_txt <- readRDS(sprintf("%s/%s.rds", rawdatadir, "news"))
#twitter_txt <- readRDS(sprintf("%s/%s.rds", rawdatadir, "twitter"))

#load("blogs.rds")
#load("news.rds")
#load("twitter.rds")

# sample data 
#sample_blogs   <- sample(blogs_txt, 1000)
#sample_news    <- sample(news_txt, 1000)
#sample_twitter <- sample(twitter_txt, 1000)
#final <- c(sample_blogs,sample_news,sample_twitter)
# save sample data
#saveRDS(final, sprintf("%s/%s.rds", rawdatadir, "sample_data"))
