###Phenotyping
library(readr)
library(ggplot2)

### Read file and remove dead and absent data

phenostable <- read_csv("Desktop/Phenotable.csv")

phenostable_no_death <- phenostable[phenostable$Height != 0,]

phenostable_alive<-phenostable_no_death[complete.cases(phenostable_no_death),]

phenostable_alive$rockdust <- sub('y', 'rockdust', phenostable_alive$rockdust)

phenostable_alive$rockdust <- sub('n', 'sand', phenostable_alive$rockdust)

phenostable_alive$motherrockdust <- paste(phenostable_alive$Mother,phenostable_alive$rockdust)

write.csv(phenostable_alive, "Desktop/treeheight.csv", row.names = F)

### Generate graphs

par(mar=c(6,5,2,2))

boxplot(phenostable_alive$Height~phenostable_alive$section, las=2, main='Height x Section', ylab='Height')

par(mar=c(7,5,2,2))

boxplot(phenostable_alive$Height~phenostable_alive$Mother, las=2, main='Height x Motherspecies', ylab='Height', xlab ='')

par(mar=c(2,5,2,2))

boxplot(phenostable_alive$Height~phenostable_alive$rockdust, main='Effect of rockdust on height', ylab='Height')

par(mar=c(10,5,2,2))

boxplot(phenostable_alive$Height~phenostable_alive$motherrockdust, las=2, ylab='Height', main='Height x Rockdust/ Motherspecies')

ggplot(phenostable_alive, aes(x=phenostable_alive$rockdust, y=phenostable_alive$Height))+ geom_boxplot() + 
  ggtitle('Effect of rockdust on height') + ylab('Height') + xlab('Application') + theme(text=element_text(size=20))

ggplot(phenostable_alive, aes(x=phenostable_alive$section, y=phenostable_alive$Height))+ geom_boxplot() + 
  ggtitle('Effect of rockdust on height') + ylab('Height') + xlab('Application') + theme(text=element_text(size=20))

ggplot(phenostable_alive, aes(x=phenostable_alive$Mother, y=phenostable_alive$Height)) + geom_boxplot() +
  ggtitle('Mother species impact on Height') + ylab('Height') + xlab('Mother') + theme(text=element_text(size=20))

### Statistics

Rockdust <- aov(phenostable_alive$Height~phenostable_alive$+phenostable_alive$rockdust, data=phenostable_alive)

Motherrockdust <- aov(phenostable_alive$Height~phenostable_alive$Mother+phenostable_alive$rockdust, data=phenostable_alive)

section <- aov(phenostable_alive$Height~phenostable_alive$section, data=phenostable_alive)

summary(Motherrockdust)

summary(section)
