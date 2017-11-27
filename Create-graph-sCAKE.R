###########################################################
#                                                         #
#         Create Context-Aware Graphs for sCAKE           #
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

f <- "path/to/Datasets/myDocument.txt" # The original text document
file_id = as.character(file_path_sans_ext(f))
df_pos = readRDS(paste0("path/to/Positions/",file_id,".Rda")) # read the positions file for the text document
  
texts<-readChar(f, file.info(f)$size)
sent1 = convert_text_to_sentences(texts)
sent = NULL
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
  
  
selected_words <- df_pos$words # the words in the position information file are the candidates
# remove empty words, if any
index = which(selected_words== "") 
if(length(index) > 0){
  selected_words = selected_words[-index]
}
  
  
# create document-term matrix
# NOTE: Alternatively, you may create term-document matrix
dtm = DocumentTermMatrix(corp) 
dtm = dtm[,colnames(dtm)%in%selected_words]
dtm = as.matrix(dtm)
dtm[dtm > 1] <- 1
ttm = t(dtm) %*% dtm # create term-term matrix
diag(ttm) <- 0


# Following code is a sample to create graphs from ttm
# g = graph.adjacency(ttm, mode = "undirected", weighted = TRUE) # create graph from ttm
# g<- simplify(g, remove.multiple = T, remove.loops = T) # make g a simple graph without self loops and multiple edges
# g_data = as_data_frame(g, what = "edges")
  
c = "path/to/Graphs/sCAKE/"
sfile1 = paste(c, file_id, sep = "")
sfile1 = paste(sfile1,"Rda",sep=".")
saveRDS(ttm, file = sfile1)