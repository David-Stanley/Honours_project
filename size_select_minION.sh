#!/bin/bash

#this script will ensure that all minION datasets have the same amount of bases

echo 'albens'
seqtk sample '/home/davids/MinION_raw_dataset/albens.fastq.gz' 971573 | gzip > /home/davids/MinION_filt_size_selected/albens.fastq.gz


echo 'marg'
seqtk sample '/home/davids/MinION_raw_dataset/marginata.fastq.gz' 812160 | gzip > /home/davids/MinION_filt_size_selected/marginata.fastq.gz  
 

echo 'mel'
seqtk sample '/home/davids/MinION_raw_dataset/mel.fastq.gz' 1030903 | gzip > /home/davids/MinION_filt_size_selected/mel.fastq.gz  
 

echo 'sid'
seqtk sample '/home/davids/MinION_raw_dataset/sid.fastq.gz' 131373 | gzip > /home/davids/MinION_filt_size_selected/sid.fastq.gz  
 

