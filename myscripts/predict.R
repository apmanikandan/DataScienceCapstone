options(mc.cores=1)
setwd("/Users/manikandanap/Capstone/")
lang <- "en_US"
rawdatadir <- "data/raw"
cleandatadir <- "data/clean"

# load the libraries
library(e1071)

# load the model
load("tri_naiveBayes.rds")

# create a test string
input_word <- "you im"

prediction <- function(input_word) {
# split it into separate words
        word_split <- strsplit(input_word, split = " " )
# encode as a factor using the same levels
        test_factor <- factor(unlist(word_split), levels=unigram_levels)
# transform to data frame
        test_df <- data.frame(X1 = test_factor[1], X2 = test_factor[2])
# estimate using the model
        estimated <- predict(tri_naiveBayes, test_df)
        outword <- factor(estimated)
        return(outword)
}

