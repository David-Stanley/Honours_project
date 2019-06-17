library(readr)
library(ggplot2)

CCA_ref <- read.csv("/media/dave/minION_Dave/Simulated_Mash/Metadata/CCATreesCombinedMetadata_altered_v1.csv")

Coverage <- read_csv("Desktop/FASTQC_all.csv")

species <- CCA_ref$CurrentName[match(Coverage$Name, CCA_ref$FieldID)]
Coverage$Name <- paste(Coverage$Name, species)


q <- ggplot(data=Coverage, aes(x=Name, y=Sequences)) +
  geom_bar(stat="identity") + ggtitle('Number of Sequences per Sample')

q + theme(axis.text.x = element_text(angle = 90, hjust = 1))


library(scales)

ggplot(Coverage[Coverage$Name!="NA",], aes(Name, Sequences, fill=Sequences)) +
  geom_bar(stat="identity") +
  geom_text(aes(label=Name), vjust=-0.5) +
  xlab("Sample")+
  ylab("Yield (bp)") +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(), legend.position = "none")+
  scale_y_continuous(breaks=pretty_breaks(n=14),labels = comma)+
  scale_fill_gradient(high='chartreuse1', low = 'maroon2', trans='log') +
  NULL # makes it easier to rearrange lines

