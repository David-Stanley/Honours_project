#!/usr/bin/env Rscript
library(reshape2)
library(devtools)
library(ggplot2)
library(ggfortify)
library(e1071)
library(pheatmap)
library(RColorBrewer)
library(grid) 
library(ape)
library(sparcl)
library(dendextend)
library(dplyr)
library(raster)

args <- commandArgs(TRUE)
Mashname <- args[1]


########################################################################################################################
### Metadata ###
CCA_ref <- read.csv("/media/dave/minION_Dave/Simulated_Mash/Metadata/CCATreesCombinedMetadata_altered_v1.csv")

########################################################################################################################
########################################################################################################################

### CURRENCY CREEK ###

## Generate currency creek data
cca_data <- read.delim('/media/dave/minION_Dave/Simulated_Mash/TSV/CCA_reference_better.tsv', header=FALSE)
colnames(cca_data) <- c("ref", "query", "dist", "pval", "hashes")

# strip non-identifying info from query field
cca_data$query <- sub("/.*/","", cca_data$query)
cca_data$query <- sub(".fastq.gz","", cca_data$query, fixed=T)
cca_data$query <- sub("_S.*","", cca_data$query)

# strip non-identifying info from reference field
cca_data$ref <- sub("/.*/","", cca_data$ref)
cca_data$ref <- sub(".fastq.gz","", cca_data$ref, fixed=T)
cca_data$ref <- sub("_S.*","", cca_data$ref)

cca_data$species <- cca_data$CurrentName[match(cca_data$query, CCA_ref$FieldID)]
cca_data$query <- paste(cca_data$query,cca_data$species)

cca_data$species <- CCA_ref$CurrentName[match(cca_data$ref, CCA_ref$FieldID)]
cca_data$ref <- paste(cca_data$ref,cca_data$species)

cca_data<-dcast(cca_data,ref~query, value.var = "dist", mean)

cca_data <- data.frame(cca_data[,-1], row.names=cca_data[,ncol(cca_data[1])])



cca_dist = dist(cca_data, method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

deno_cca = as.dendrogram(hclust(dist(cca_data, method = "euclidean", diag = FALSE, upper = FALSE, p = 2)))



########################################################################################################################
########################################################################################################################

### MINION MASH ###
#mash_processed <- read.delim('/media/dave/minION_Dave/Simulated_Mash/TSV/species_all_coverages/albens_all.tsv', header=FALSE)
mash_processed <- read.delim(Mashname, header=FALSE)
colnames(mash_processed) <- c("ref", "query", "dist", "pval", "hashes")

# strip non-identifying info from query field
mash_processed$query <- sub("/.*/","", mash_processed$query)
mash_processed$query <- sub(".fastq.gz","", mash_processed$query, fixed=T)
mash_processed$query <- sub("_S.*","", mash_processed$query)

# strip non-identifying info from reference field
mash_processed$ref <- sub("/.*/","", mash_processed$ref)
mash_processed$ref <- sub(".fastq.gz","", mash_processed$ref, fixed=T)
mash_processed$ref <- sub("_S.*","", mash_processed$ref)



# generate better names for query
mash_processed$species <- CCA_ref$CurrentName[match(mash_processed$query, CCA_ref$FieldID)]
mash_processed$query <- paste(mash_processed$query,mash_processed$species)




#Transform data
mash_processed<-dcast(mash_processed,ref~query, value.var = "dist", mean)

##Generate rownames
mash_processed <- data.frame(mash_processed[,-1], row.names=mash_processed[,ncol(mash_processed[1])])
mash_processed[mash_processed == 1] <- NA

mash_processed <- mash_processed[c(order.dendrogram(deno_cca))]



########################################################################################################################
########################################################################################################################

### GRAPH GENERATION ###



#Everything

Everything_outname=paste('/media/dave/minION_Dave/Simulated_Mash/mash_all_coverages_R_images/Everything_', tools::file_path_sans_ext(basename(Mashname)),'.png', sep="")

pheatmap(mash_processed[], cluster_cols = F, cluster_rows = F, na_col = 'black', labels_row=paste(""), filename=Everything_outname, fontsize_col = 3, ylab='Albens')

mash_processed <- subset(mash_processed, select=-c(CCA0525.Eucalyptus.porosa))

#from https://stackoverflow.com/a/21005136
minN <- function(x, N){
  len <- length(x)
  if(N>len){
    warning('N greater than length(x).  Setting N=length(x)')
    N <- length(x)
  }
  M=len-N+1 #hacky way to do Nth-minimum value
  # from https://stackoverflow.com/a/5577776
  sort(x,partial=len-M+1)[len-M+1]
}

screen1<-c()
screen2<-c()
screen3<-c()
screen4<-c()
screen5<-c()


i<-1
while (i <= length(mash_processed[,1])) {
  j=1
  screen1<-c(screen1,colnames(minN(mash_processed[i,],1)))
  screen2<-c(screen2,colnames(minN(mash_processed[i,],2)))
  screen3<-c(screen3,colnames(minN(mash_processed[i,],3)))
  screen4<-c(screen4,colnames(minN(mash_processed[i,],4)))
  screen5<-c(screen5,colnames(minN(mash_processed[i,],5)))
  i = i+1
}


screen <- data.frame(first_distance = apply(mash_processed, 1, FUN = function(mash_processed) tail(sort(mash_processed), 193)[1]),
                     first_species = screen1,
                     second_distance = apply(mash_processed, 1, FUN = function(mash_processed) tail(sort(mash_processed), 192)[1]),
                     second_species = screen2,
                     third_distance = apply(mash_processed, 1, FUN = function(mash_processed) tail(sort(mash_processed), 191)[1]),
                     third_species = screen3,
                     fourth_distance = apply(mash_processed, 1, FUN = function(mash_processed) tail(sort(mash_processed), 190)[1]),
                     fourth_species = screen4,
                     fifth_distance = apply(mash_processed, 1, FUN = function(mash_processed) tail(sort(mash_processed), 189)[1]),
                     fifth_species = screen5)



#Removes the rep and cca names from the list

screen1 <- gsub("^.*?\\.","",screen1)


screen_table<-as.data.frame(table(unlist(screen)))

s1 <- as.data.frame(table(unlist(screen1[1:100])))
s2 <- as.data.frame(table(unlist(screen1[101:200])))
s3 <- as.data.frame(table(unlist(screen1[201:300])))
s4 <- as.data.frame(table(unlist(screen1[301:400])))
s5 <- as.data.frame(table(unlist(screen1[401:500])))



s1$coverage <- '0.2'
s2$coverage <- '0.5'
s3$coverage <- '1'
s4$coverage <- '2'
s5$coverage <- '5'


colnames(s1) <- c('Species', 'Frequency', 'Coverage')
colnames(s2) <- c('Species', 'Frequency', 'Coverage')
colnames(s3) <- c('Species', 'Frequency', 'Coverage')
colnames(s4) <- c('Species', 'Frequency', 'Coverage')
colnames(s5) <- c('Species', 'Frequency', 'Coverage')


screen_all <- rbind(s1 ,s2 ,s3, s4, s5)

par(mfrow=c(1,1))

ggplot(data=s1, aes(x=Species, y=Frequency, fill=Species)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data=s2, aes(x=Species, y=Frequency, fill=Species)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data=s3, aes(x=Species, y=Frequency, fill=Species)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data=s4, aes(x=Species, y=Frequency, fill=Species)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data=s5, aes(x=Species, y=Frequency, fill=Species)) +
  geom_bar(stat="identity") + coord_flip()

bigname=paste('Closest_species_kmer_for_', tools::file_path_sans_ext(basename(Mashname)), sep="")

big <- ggplot(data=screen_all, aes(x=Species, y=Frequency, fill=Coverage)) +
  geom_bar(stat="identity", position = position_dodge2()) + coord_flip() + ggtitle(bigname)

Everything_outname=paste('/media/dave/minION_Dave/Simulated_Mash/mash_all_coverages_R_images/kmeridentity', tools::file_path_sans_ext(basename(Mashname)),'.png', sep="")

ggsave(filename=Everything_outname, plot = big)



### MINION MASH ###
#mash_processed <- read.delim('/media/dave/minION_Dave/Simulated_Mash/TSV/species_all_coverages/albens_all.tsv', header=FALSE)
mash_processed <- read.delim(Mashname, header=FALSE)
colnames(mash_processed) <- c("ref", "query", "dist", "pval", "hashes")

# strip non-identifying info from query field
mash_processed$query <- sub("/.*/","", mash_processed$query)
mash_processed$query <- sub(".fastq.gz","", mash_processed$query, fixed=T)
mash_processed$query <- sub("_S.*","", mash_processed$query)

# strip non-identifying info from reference field
mash_processed$ref <- sub("/.*/","", mash_processed$ref)
mash_processed$ref <- sub(".fastq.gz","", mash_processed$ref, fixed=T)
mash_processed$ref <- sub("_S.*","", mash_processed$ref)



# generate better names for query
mash_processed$species <- CCA_ref$Section[match(mash_processed$query, CCA_ref$FieldID)]
mash_processed$query <- paste(mash_processed$query,mash_processed$species)




#Transform data
mash_processed<-dcast(mash_processed,ref~query, value.var = "dist", mean)

##Generate rownames
mash_processed <- data.frame(mash_processed[,-1], row.names=mash_processed[,ncol(mash_processed[1])])
mash_processed[mash_processed == 1] <- NA





#from https://stackoverflow.com/a/21005136
minN <- function(x, N){
  len <- length(x)
  if(N>len){
    warning('N greater than length(x).  Setting N=length(x)')
    N <- length(x)
  }
  M=len-N+1 #hacky way to do Nth-minimum value
  # from https://stackoverflow.com/a/5577776
  sort(x,partial=len-M+1)[len-M+1]
}

screen1<-c()
screen2<-c()
screen3<-c()
screen4<-c()
screen5<-c()


i<-1
while (i <= length(mash_processed[,1])) {
  j=1
  screen1<-c(screen1,colnames(minN(mash_processed[i,],1)))
  screen2<-c(screen2,colnames(minN(mash_processed[i,],2)))
  screen3<-c(screen3,colnames(minN(mash_processed[i,],3)))
  screen4<-c(screen4,colnames(minN(mash_processed[i,],4)))
  screen5<-c(screen5,colnames(minN(mash_processed[i,],5)))
  i = i+1
}


screen <- data.frame(first_distance = apply(mash_processed, 1, FUN = function(mash_processed) tail(sort(mash_processed), 193)[1]),
                     first_species = screen1,
                     second_distance = apply(mash_processed, 1, FUN = function(mash_processed) tail(sort(mash_processed), 192)[1]),
                     second_species = screen2,
                     third_distance = apply(mash_processed, 1, FUN = function(mash_processed) tail(sort(mash_processed), 191)[1]),
                     third_species = screen3,
                     fourth_distance = apply(mash_processed, 1, FUN = function(mash_processed) tail(sort(mash_processed), 190)[1]),
                     fourth_species = screen4,
                     fifth_distance = apply(mash_processed, 1, FUN = function(mash_processed) tail(sort(mash_processed), 189)[1]),
                     fifth_species = screen5)



#Removes the rep and cca names from the list

screen1 <- gsub("^.*?\\.","",screen1)


screen_table<-as.data.frame(table(unlist(screen)))

s1 <- as.data.frame(table(unlist(screen1[1:100])))
s2 <- as.data.frame(table(unlist(screen1[101:200])))
s3 <- as.data.frame(table(unlist(screen1[201:300])))
s4 <- as.data.frame(table(unlist(screen1[301:400])))
s5 <- as.data.frame(table(unlist(screen1[401:500])))



s1$coverage <- '0.2'
s2$coverage <- '0.5'
s3$coverage <- '1'
s4$coverage <- '2'
s5$coverage <- '5'


colnames(s1) <- c('Species', 'Frequency', 'Coverage')
colnames(s2) <- c('Species', 'Frequency', 'Coverage')
colnames(s3) <- c('Species', 'Frequency', 'Coverage')
colnames(s4) <- c('Species', 'Frequency', 'Coverage')
colnames(s5) <- c('Species', 'Frequency', 'Coverage')


screen_all <- rbind(s1 ,s2 ,s3, s4, s5)

par(mfrow=c(1,1))

ggplot(data=s1, aes(x=Species, y=Frequency, fill=Species)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data=s2, aes(x=Species, y=Frequency, fill=Species)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data=s3, aes(x=Species, y=Frequency, fill=Species)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data=s4, aes(x=Species, y=Frequency, fill=Species)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data=s5, aes(x=Species, y=Frequency, fill=Species)) +
  geom_bar(stat="identity") + coord_flip()

bigname=paste('Closest_section_kmer_for_', tools::file_path_sans_ext(basename(Mashname)), sep="")

big <- ggplot(data=screen_all, aes(x=Species, y=Frequency, fill=Coverage)) +
  geom_bar(stat="identity", position = position_dodge2()) + coord_flip() + ggtitle(bigname)

Everything_outname=paste('/media/dave/minION_Dave/Simulated_Mash/mash_all_coverages_R_images/kmeridentity_section', tools::file_path_sans_ext(basename(Mashname)),'.png', sep="")

ggsave(filename=Everything_outname, plot = big)


