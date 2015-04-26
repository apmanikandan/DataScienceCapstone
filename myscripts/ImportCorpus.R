# We will use the English files

# 1.Import the datasets 
# 2. Remove non UTF-8 characters
# 3. Save the datasets in .Rdata format as it's compressed and it takes shorter time to load the files in R

setwd("/Users/manikandanap/Capstone")
lang <- "en_US"
rawdatadir <- "data/raw"

for (src in c('blogs', 'news', 'twitter')) {
        txt <- readLines(sprintf("%s/final/%s/%s.%s.txt", rawdatadir, lang, lang, src),n=lines, skipNul = T,
                         encoding="UTF-8")
        txt <- iconv(txt, from = "latin1", to = "UTF-8", sub="")
        txt <- stri_replace_all_regex(txt, "\u2019|`","'")
        txt <- stri_replace_all_regex(txt, "\u201c|\u201d|u201f|``",'"')
        saveRDS(txt, sprintf("%s/%s.rds", rawdatadir, src))
}
