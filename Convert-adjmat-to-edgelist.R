############################################
#             Create Edgelist              #
############################################

library(foreign)
library(igraph)
library(tools)

setwd("path/to/Datasets/") # set working directory to the folder with your text documents

f = "myDocument.Rda" # graph file for the text document
file_id = as.character(file_path_sans_ext(f))

df1 = readRDS(f)   #### read .rda file, loads data frame
gr = graph.adjacency(df1, mode = "undirected", weighted = TRUE)  # create graph from stored adjacency matrix 
edgel = get.data.frame(gr, "edges") # create edgelist
path = "path/to/Edgelist/"
f_n = paste0(path, file_id, ".csv") 
#save edgelist, contents separated by \t
write.table(edgel,file = f_n,sep="\t",row.names=F, col.names = F)
