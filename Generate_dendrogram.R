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
cca_data$section <- CCA_ref$Section[match(cca_data$ref, CCA_ref$FieldID)]
cca_data$series <- CCA_ref$Series[match(cca_data$ref, CCA_ref$FieldID)]
cca_data$subgenus <- CCA_ref$Subgenus[match(cca_data$ref, CCA_ref$FieldID)]

#cca_data$ref <- paste(cca_data$species)
cca_data$ref <- paste(cca_data$subgenus, cca_data$section, cca_data$series, cca_data$species)

cca_data<-dcast(cca_data,ref~query, value.var = "dist", mean)

cca_data <- data.frame(cca_data[,-1], row.names=cca_data[,ncol(cca_data[1])])

cca_data <- subset(cca_data, select=-c(blank.,Blank2.))

cca_data <- cca_data[rownames(cca_data)!='NA',]

cca_dist = dist(cca_data, method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

deno_cca = as.dendrogram(hclust(dist(cca_data, method = "euclidean", diag = FALSE, upper = FALSE, p = 2)))


##################Graph time########################
plot(as.phylo(deno_cca), cex = 0.9)

plot(deno_cca)

### PCAS

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
cca_data$section <- CCA_ref$Section[match(cca_data$ref, CCA_ref$FieldID)]
cca_data$series <- CCA_ref$Series[match(cca_data$ref, CCA_ref$FieldID)]
cca_data$subgenus <- CCA_ref$Subgenus[match(cca_data$ref, CCA_ref$FieldID)]

#cca_data$ref <- paste(cca_data$ref, cca_data$species)

cca_data<-dcast(cca_data,ref~query, value.var = "dist", mean)

cca_data$section <- CCA_ref$Section[match(cca_data$ref, CCA_ref$FieldID)]

cca_data$species <- CCA_ref$CurrentName[match(cca_data$ref, CCA_ref$FieldID)]
cca_data$ref <- paste(cca_data$ref, cca_data$species)


cca_data <- data.frame(cca_data[,-1], row.names=cca_data[,ncol(cca_data[1])])

cca_data <- subset(cca_data, select=-c(blank.,Blank2.))



cca_data <- cca_data[rownames(cca_data)!='blank NA',]
cca_data <- cca_data[rownames(cca_data)!='Blank2 NA',]

cca_data <- cca_data[order(cca_data$section),]

write.csv(cca_data, "/media/dave/minION_Dave/sections_ordered.csv")
cca_dist = dist(cca_data[1:191,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_dist), data=cca_data[1:191,1:191], label=TRUE, label.size= 3, shape=FALSE)



