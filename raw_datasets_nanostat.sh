#!/bin/bash



#### This script is to generate a csv of the number of reads in a fastq
# to determine how to subsample at different coverages

for f in /home/davids/MinION_raw_dataset/*.fastq.gz; do
	name=${f%.*}
        name=${name%.*}
        name=$(basename $name)
	echo 'nanostat' ${name}
	NanoStat --fastq ${f} > /home/davids/NanoStats/raw_minION_fastq/${name}.txt
	done

heading='name, mean_read_length, mean_read_quality, median_read_length, median_read_quality, number_of_reads, total_bases'
rm -f /home/davids/NanoStats/raw_minION_fastq/all_reads_minION.csv
printf '%s\n' ${heading} | paste -sd '' >> /home/davids/NanoStats/raw_minION_fastq/all_reads_minION.csv

for f in /home/davids/NanoStats/raw_minION_fastq/*.txt; do
	name=${f%.*}
        name=${name%.*}
        name=$(basename $name)
	echo 'accessing reads' ${name}
	awk -F':' '{print $2}' ${f} > /home/davids/NanoStats/raw_minION_fastq/temp
	mean_read_length=$(cat /home/davids/NanoStats/raw_minION_fastq/temp | head -n 2 | tail -n 1 | sed 's/\,//g')
	mean_read_quality=$(cat /home/davids/NanoStats/raw_minION_fastq/temp | head -n 3 | tail -n 1 | sed 's/\,//g')
	median_read_length=$(cat /home/davids/NanoStats/raw_minION_fastq/temp | head -n 4 | tail -n 1 | sed 's/\,//g')
        median_read_quality=$(cat /home/davids/NanoStats/raw_minION_fastq/temp | head -n 5 | tail -n 1 | sed 's/\,//g')
	num_reads=$(cat /home/davids/NanoStats/raw_minION_fastq/temp | head -n 6 | tail -n 1 | sed 's/\,//g')
        num_bases=$(cat /home/davids/NanoStats/raw_minION_fastq/temp | head -n 8 | tail -n 1 | sed 's/\,//g')
	rm -f /home/davids/NanoStats/raw_minION_fastq/temp

	printf '%s\n' ${name} ',' ${mean_read_length} ',' ${mean_read_quality} ',' ${median_read_length} ',' ${median_read_quality} ',' ${num_reads} ',' ${num_bases} | paste -sd '' >> /home/davids/NanoStats/raw_minION_fastq/all_reads_minION.csv
	done

