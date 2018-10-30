###########################################################
#                                                         #
#         Create Context-Aware Graphs for LAKE            #
#                                                         #
###########################################################

library(NLP)
library(tm)
library(openNLP)
library(graph)
library(foreign)
library(igraph)
library(tools)
library(BiocGenerics)





# ------------- functions

convert_text_to_sentences <- function(text) {
  # Function to compute sentence annotations using the Apache OpenNLP Maxent sentence detector employing the default model for language 'en'. 
  sentence_token_annotator <- Maxent_Sent_Token_Annotator()
  
  # Convert text to class String from package NLP
  text <- as.String(text)
  
  # Sentence boundaries in text
  sentence.boundaries <- annotate(text, sentence_token_annotator)
  
  # Extract sentences
  sentences <- text[sentence.boundaries]
  
  # return sentences
  return(sentences)
}




# -------------- MAIN CODE

df_sigma = read.csv("path/to/Sigma/keywords_sigma.csv")
setwd("path/to/Datasets/") # set working directory to the folder with your text documents

f <- "myDocument.txt" # the text document from where keywords are to be extracted

file_id = as.character(file_path_sans_ext(f))
  
texts<-readChar(f, file.info(f)$size)
sent1 = convert_text_to_sentences(texts)
sent = NULL
# join two consecutive sentences as one - s1s2  s2s3  s3s4 ...
if(length(sent1) <= 2){
  sent = as.String(sent1)
}else{
  for(i in 1:(length(sent1)-1)){
    s = paste(sent1[i], " ", sent1[i+1])
    sent = c(sent, as.String(s))
  }
}
doc<-c(sent)

df = as.data.frame(doc) 
# Create the corpus (using VectorSource), taking two consecutive sentences as a document
corp = Corpus(VectorSource(df$doc))
corp <- tm_map(corp, stripWhitespace)
corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, removeWords, stopwords(kind = "SMART"))
  

# select top 33% words as candidates (using sigma-index rank)
df_sample = subset(df_sigma, df_sigma$fileName == file_id)
thres = round(length(df_sample$word) * 0.33) # defining threshold for top-33% words
thres = ifelse(length(which(df_sample$sigma > 0)) > thres, thres, length(which(df_sample$sigma > 0)))
selected_words <- df_sample$word[1:thres]
index = which(selected_words== "")
if(length(index) > 0){
  selected_words = selected_words[-index]
}
  
  
# create document-term matrix
dtm = DocumentTermMatrix(corp, control =  list(wordLengths=c(0, Inf)))
dtm = dtm[,colnames(dtm)%in%selected_words] # keep only candidates as terms
dtm = as.matrix(dtm)
dtm[dtm > 1] <- 1
ttm = t(dtm) %*% dtm # create term-term matrix
diag(ttm) <- 0

# Following code is a sample to create graphs from ttm
# g = graph.adjacency(ttm, mode = "undirected", weighted = TRUE) # create graph from ttm
# g<- simplify(g, remove.multiple = T, remove.loops = T) # make g a simple graph without self loops and multiple edges
# g_data = as_data_frame(g, what = "edges")
  
c = "path/to/Graphs/LAKE/"
sfile1 = paste(c, file_id, sep = "")
sfile1 = paste(sfile1,"Rda",sep=".")
saveRDS(ttm, file = sfile1)
