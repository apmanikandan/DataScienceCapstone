# Load the text into corpus and clean the corpus text and save 

#0. Read the .Rdata files from raw directory
#1. strip unwanted white space
#2. convert to lower case
#3. remove 'stopwords'
#4. remove digits,punctuations,control characters
#5. remove profanity 
#6. Text stemming for the final tidy-up
#7. Save the cleansed data in clean directory


setwd("/Users/manikandanap/Capstone")
lang <- "en_US"
rawdatadir <- "data/raw"
cleandatadir <- "data/clean"

if (!file.exists(cleandatadir)) {
        dir.create(cleandatadir, showWarnings = FALSE)
}

lines=20000

library(stringi)
require(tm)

for (src in c('blogs', 'news', 'twitter')) {
        txt <- readLines(sprintf("%s/final/%s/%s.%s.txt", rawdatadir, lang, lang, src),n=lines, skipNul = T,
                         encoding="UTF-8")
        txt <- iconv(txt, from = "latin1", to = "UTF-8", sub="")
        txt <- stri_replace_all_regex(txt, "\u2019|`","'")
        txt <- stri_replace_all_regex(txt, "\u201c|\u201d|u201f|``",'"')
        saveRDS(txt, sprintf("%s/%s.rds", rawdatadir, src))
}


#alltext <- sent_detect(all_text, language = "en", model = NULL)
cleanse <- function(corpus) {
        text <- VCorpus(VectorSource(corpus))
        text <- tm_map(text, content_transformer(tolower))
        text <- tm_map(text,content_transformer(removeNumbers))
        text <- tm_map(text,  content_transformer(removePunctuation))
        text <- tm_map(text, removeWords, stopwords('english'))
        text <- tm_map(text, content_transformer(stripWhitespace))   
        
        # Next we perform stemming, which removes affixes from words (so, for example, "run", "runs" and "running" all become "run").
        text <- tm_map(text, stemDocument)
        
        #Remove profanity and other words we do not want to predict. 
        # file available in this locations (https://github.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/blob/master/en) 
        
        ProfanityFile<-file("/Users/manikandanap/Capstone/data/raw/final/en_profanity.txt", open="rb")
        profanity<-readLines(ProfanityFile,encoding="UTF-8")
        close(ProfanityFile)
        
        text <- tm_map(text,removeWords,profanity)
        #text <- tm_map(text, PlainTextDocument)
        #tdm <- TermDocumentMatrix(text)
        #dtm <-DocumentTermMatrix(text)
}

for (src in c('blogs', 'news', 'twitter')) {
        txt <- readRDS(sprintf("./%s/%s.rds", rawdatadir, src))
        cleanse(txt)
        saveRDS(txt, sprintf("./%s/%s.rds", cleandatadir, src))
}
