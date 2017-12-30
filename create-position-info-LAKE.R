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

text_clean <- function (x) {
  # Function to clean and pre-process the input text document
  # required packages: "tm", "openNLP"
  
  # convert to lower case
  x = tolower(x)
  
  # remove extra white space
  x = gsub("\\s+"," ",x)
  
  # replace tabs with white space
  x = gsub("[/\t]"," ",x)
  
  # remove dashes
  x = gsub("- ", " ", x, perl = TRUE) 
  x = gsub(" -", " ", x, perl = TRUE)
  
  # remove parentheses
  x = gsub("\\(", " ", x, perl = TRUE) 
  x = gsub("\\)", " ", x, perl = TRUE)
  
  # remove punctuations
  x = removePunctuation(x)
  
  # remove plus and star signs
  x = gsub("+", " ", x, fixed = TRUE)
  x = gsub("*", " ", x, fixed = TRUE)
  
  # remove apostrophes that are not intra-word
  x = gsub("' ", " ", x, perl = TRUE)
  x = gsub(" '", " ", x, perl = TRUE)
  
  # remove numbers (integers and floats) but not dates like 2015
  x = gsub("\\b(?!(?:18|19|20)\\d{2}\\b(?!\\.\\d))\\d*\\.?\\d+\\b"," ", x, perl=T)
  
  # remove "e.g." and "i.e."
  x = gsub("\\b(?:e\\.g\\.|i\\.e\\.)", " \\1 ", x, perl=T)
  
  # replace "...." by "..."
  x = gsub("(\\.\\.\\.\\.)", " \\.\\.\\. ", x, perl=T)
  
  # replace ".." by "."
  x = gsub("(\\.\\.\\.)(*SKIP)(*F)|(\\.\\.)", " \\. ", x, perl=T)
  
  
  # remove leading and trailing white space
  x = str_trim(x,"both")
  
  # tokenize
  x = unlist(strsplit(x,split=" "))
  
  # make a copy of tokens without further preprocessing
  xx = x
  
  # remove stopwords
  index = which(x %in% my_stopwords)
  if (length(index)>0){
    x = x[-index]
  }
  
  # remove blank elements
  index = which(x=="")
  if (length(index)>0){
    x = x[-index]
  }
  
  index = which(xx=="")
  if (length(index)>0){
    xx = xx[-index]
  }
}



# ------------ Main Code

my_stopwords <- readLines("path/to/stopwords.txt") # reads the list of stopwords

setwd("path/to/Datasets/") # set working directory to the folder with your text documents

f <- "myDocument.txt" # the text document from where keywords are to be extracted

file_id <- as.character(file_path_sans_ext(f))
  
texts<-readChar(f, file.info(f)$size) # reads contents of the text document

# 

output <- text_clean(texts)
words <- output$unprocessed

selected_words <- output$processed
  
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
 
