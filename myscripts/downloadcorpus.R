#set working directory
setwd("/Users/manikandanap/Capstone")
#Download corpus and unzip
if (!file.exists("data")) {
        dir.create("data", showWarnings = FALSE)
        dir.create("data/raw", showWarnings = FALSE)
}

{
        url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
        fileName = "data/raw/Coursera-SwiftKey.zip"
        download.file(url, destfile = fileName)
        unzip(fileName, exdir = "data/raw")
}
