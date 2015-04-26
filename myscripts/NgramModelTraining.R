library(tm)
library(RWeka)
library(dplyr)
library(magrittr)

options(mc.cores=1)

setwd("/Users/manikandanap/Capstone/data/clean")
lang <- "en_US"
rawdatadir <- "data/raw"
cleandatadir <- "data/clean"

# load the sample data (all.training data set)
all_train <- readRDS(sprintf("all.train.rds", cleandatadir))

#filter <- c("<URL>", "<U>", "<S>", "<NN>", "<ON>", "<N>", "<T>" , "<D>", "<PN>", "<EMAIL>", "<HASH>", "<YN>", "<TW>")

# ngram tokenizer
unigram_token <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
bigram_token <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2,delimiters = " \\r\\n\\t.,;:\"()?!"))
trigram_token <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3,delimiters = " \\r\\n\\t.,;:\"()?!"))
tetragram_token <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4,delimiters = " \\r\\n\\t.,;:\"()?!"))

# check length function
length_is <- function(n) function(x) length(x)==n

# Construct the corpus (we will use magrittr operator %>%)
vc_all <-
        all_train %>%
        data.frame() %>%
        DataframeSource() %>%
        VCorpus %>%
        tm_map( stripWhitespace )

# Get the frequency of unigrams using term document matrix
tdm_unigram <-
        vc_all %>%
        TermDocumentMatrix( control = list( removePunctuation = TRUE,
                                            removeNumbers = TRUE,
                                            wordLengths = c( 1, Inf) )
        )

freq_unigram <- 
        tdm_unigram %>%
        as.matrix %>%
        rowSums

# write all unigrams to a list
# in order to create uniform levels of factors

unigram_levels <- unique(tdm_unigram$dimnames$Terms)

# Get the frequency of trigram using term document matrix
tdm_trigram <-
        vc_all %>%
        TermDocumentMatrix( control = list( removePunctuation = TRUE,
                                            removeNumbers = TRUE,
                                            wordLengths = c(1, Inf),tokenize = trigram_token)
                            )

# aggregate frequencies
tdm_trigram %>%
        as.matrix %>%
        rowSums -> freq_trigram

# repeat by frequency (magrittr compound assignment pipe-operator used to Pipe the object forward into a function or call the expression and 
# update the lhs object with the resulting value.)
freq_trigram %<>%
        names %>%
        rep( times = freq_trigram )

# split the trigram into three columns
freq_trigram %<>%
        strsplit(split=" ")

# filter out those of less than three columns
freq_trigram <- do.call(rbind, 
                        Filter( length_is(3),
                                freq_trigram )
)

# transform to data.frame encode as factors
df_trigram <- data.frame(X1 = factor(freq_trigram[,1], levels = unigram_levels),
                         X2 = factor(freq_trigram[,2], levels = unigram_levels),
                         Y  = factor(freq_trigram[,3], levels = unigram_levels) )

#df_trigram <- df_trigram[order("X1","X2","Y"),]

# save data frame
save( df_trigram, unigram_levels, file = "df_trigram.rds")

# Model Training 

# Train the model using Naive Bayes Classifier
# Load the required library and data frame

library(e1071)
load("df_trigram.rds")

#use formula of the form class Y ~ x1 + x2 on data frame of predictors
tri_naiveBayes <- naiveBayes( Y ~ X1 + X2 ,df_trigram )

save(tri_naiveBayes, unigram_levels, file = "tri_naiveBayes.rds")

