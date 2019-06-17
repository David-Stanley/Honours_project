library(reshape2)
library(dplyr)


########################################################################################################################
### Metadata ###
CCA_ref <- read.csv("/media/dave/minION_Dave/Simulated_Mash/Metadata/CCATreesCombinedMetadata_altered_v1.csv")

########################################################################################################################
########################################################################################################################

########################################################################################################################
########################################################################################################################

### MINION MASH ###

mash_processed <- read.delim('/media/dave/minION_Dave/Simulated_Mash/TSV/real_minion.tsv', header=FALSE)
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


write.csv(mash_processed, "/media/dave/minION_Dave/real_minion.csv")
