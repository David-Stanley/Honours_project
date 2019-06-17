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


cca_adna <- read.csv("/home/dave/Desktop/Sections/Adnataria.csv")

cca_adna <- data.frame(cca_adna[,-1], row.names=cca_adna[,ncol(cca_data[1])])

cca_adna_dist = dist(cca_adna[,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_adna_dist), data=cca_adna[,1:191], label=TRUE, label.size= 3, shape=FALSE)

cca_adna <- cca_adna[rownames(cca_adna)!='CCA0525 Eucalyptus porosa',]

cca_adna_dist = dist(cca_adna[,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_adna_dist), data=cca_adna[,1:191], label=TRUE, label.size= 3, shape=FALSE)



cca_maid <- read.csv("/home/dave/Desktop/Sections/Maidenaria.csv")

cca_maid <- data.frame(cca_maid[,-1], row.names=cca_maid[,ncol(cca_data[1])])

cca_maid_dist = dist(cca_maid[,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_maid_dist), data=cca_maid[,1:191], label=TRUE, label.size= 3, shape=FALSE)

cca_maid <- cca_maid[rownames(cca_maid)!='CCA3217 Eucalyptus globulus',]

cca_maid_dist = dist(cca_maid[,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_maid_dist), data=cca_maid[,1:191], label=TRUE, label.size= 3, shape=FALSE)



cca_bi <- read.csv("/home/dave/Desktop/Sections/Bisect.csv")

cca_bi <- data.frame(cca_bi[,-1], row.names=cca_bi[,ncol(cca_data[1])])

cca_bi_dist = dist(cca_bi[,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_bi_dist), data=cca_bi[,1:191], label=TRUE, label.size= 3, shape=FALSE)

cca_bi <- cca_bi[rownames(cca_bi)!='CCA3250 Eucalyptus squamosa',]
cca_bi <- cca_bi[rownames(cca_bi)!='CCA0266 Eucalyptus delicata',]

cca_bi_dist = dist(cca_bi[,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_bi_dist), data=cca_bi[,1:191], label=TRUE, label.size= 3, shape=FALSE)



cca_euc <- read.csv("/home/dave/Desktop/Sections/Eucalyptus.csv")

cca_euc <- data.frame(cca_euc[,-1], row.names=cca_euc[,ncol(cca_data[1])])

cca_euc_dist = dist(cca_euc[,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_euc_dist), data=cca_euc[,1:191], label=TRUE, label.size= 3, shape=FALSE)

cca_euc <- cca_euc[rownames(cca_euc)!='CCA0790 Eucalyptus sparsifolia',]
cca_euc <- cca_euc[rownames(cca_euc)!='CCA0684 Eucalyptus macrorhyncha subsp. macrorhyncha',]

cca_euc_dist = dist(cca_euc[,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_euc_dist), data=cca_euc[,1:191], label=TRUE, label.size= 3, shape=FALSE)



cca_ex <- read.csv("/home/dave/Desktop/Sections/Exsertaria.csv")

cca_ex <- data.frame(cca_ex[,-1], row.names=cca_ex[,ncol(cca_data[1])])

cca_ex_dist = dist(cca_ex[,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_ex_dist), data=cca_ex[,1:191], label=TRUE, label.size= 3, shape=FALSE)

cca_ex_dist = dist(cca_ex[,1:191], method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

autoplot(prcomp(cca_ex_dist), data=cca_ex[,1:191], label=TRUE, label.size= 3, shape=FALSE)
