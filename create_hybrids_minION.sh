#!/bin/bash 

### This script produces hybrids

echo 'albxmarg'
zcat /home/davids/MinION_filt_size_selected/albens.fastq.gz /home/davids/MinION_filt_size_selected/marginata.fastq.gz |gzip > /home/davids/MinION_raw_dataset/albxmarg.fastq.gz

echo 'albxmel'
zcat /home/davids/MinION_filt_size_selected/albens.fastq.gz /home/davids/MinION_filt_size_selected/mel.fastq.gz |gzip > /home/davids/MinION_raw_dataset/albxmel.fastq.gz

echo 'albxsid'
zcat /home/davids/MinION_filt_size_selected/albens.fastq.gz /home/davids/MinION_filt_size_selected/sid.fastq.gz |gzip > /home/davids/MinION_raw_dataset/albxsid.fastq.gz

echo 'margxmel'
zcat /home/davids/MinION_filt_size_selected/marginata.fastq.gz /home/davids/MinION_filt_size_selected/mel.fastq.gz |gzip > /home/davids/MinION_raw_dataset/margxmel.fastq.gz

echo 'margxsid'
zcat /home/davids/MinION_filt_size_selected/marginata.fastq.gz /home/davids/MinION_filt_size_selected/sid.fastq.gz |gzip > /home/davids/MinION_raw_dataset/margxsid.fastq.gz

echo 'melxsid'
zcat /home/davids/MinION_filt_size_selected/mel.fastq.gz /home/davids/MinION_filt_size_selected/sid.fastq.gz |gzip > /home/davids/MinION_raw_dataset/melxsid.fastq.gz
