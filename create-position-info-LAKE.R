##############################################################################
#               Create data frame for positions of word occurrence           #
#                               For LAKE method                              #
#                     (Taken help from online repositories)                  #
##############################################################################



library(NLP)
library(tm)
library(openNLP)
library(foreign)
library(stringr)
library(tools)



# ------------- FUNCTIONS

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

IsPunctuated <- function(Phrase) {
  length(grep("\\.|-|,|!|\\?|;|:|\\)|]|}\\Z",Phrase,perl=TRUE))>0 # punctuation: . , ! ? ; : ) ] }
}

SelectTaggedWords <- function(Words,tagID) {
  Words[ grep(tagID,Words) ]
}

RemoveTags <- function(Words) {
  sub("/[A-Z]{2,3}","",Words)
}

SplitText <- function(Phrase) { 
  unlist(strsplit(Phrase," "))
}


# ------------ Main Code

my_stopwords <- readLines("path/to/stopwords.txt") # reads the list of stopwords

setwd("path/to/Datasets/") # set working directory to the folder with your text documents

f <- "myDocument.txt" # the text document from where keywords are to be extracted

file_id <- as.character(file_path_sans_ext(f))
  
texts<-readChar(f, file.info(f)$size) # reads contents of the text document

# 

doc<-c(texts)
corp <- Corpus(VectorSource(doc))
corp <- tm_map(corp, stripWhitespace)
corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, removeWords, my_stopwords)
corp <- tm_map(corp, stemDocument, language = "english")

words <- SplitText(as.character(corp[[1]]))
words = gsub("\\b[i|v|x|l|c|d|m]{1,3}\\b", "", words)
if(length(which(words == "")) > 0)
  words = words[-which(words == "")]
  
selected_words = unique(words)

N = length(words) + 1
  
t = NULL
posi = list()
tf = NULL
i = 1
pos_w = NULL
  
for (w in selected_words) {
  posw <- which(w==words)
  w_freq <- length(posw)
  posw = c(posw,N)
    
  t = c(t, w)
  tf = c(tf, w_freq)
  posi[[i]] = posw
  i=i+1
}
  
pos_w = as.array(posi)
    

  
term_freq = data.frame(t,tf,pos_w)
names(term_freq) = c("words","tf","positions")
  
 
c = "path/to/Positions/"
sfile1 = paste(c, file_id, sep = "")
sfile1 = paste(sfile1,"Rda",sep=".")
  
saveRDS(term_freq,file = sfile1)
 
