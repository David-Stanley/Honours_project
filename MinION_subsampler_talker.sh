#!/bin/bash


echo 'Here we go!'
awk -F',' '{print $2}' /home/davids/NanoStats/raw_minION_fastq/all_reads_minION.csv > /home/davids/NanoStats/raw_minION_fastq/mean_read_length_column
heading='name, mean_read_length, mean_read_quality, median_read_length, median_read_quality, number_of_reads, total_bases'



##Change these
read -p 'What coverage would you like?: ' coverage
genome_size=675500000
read -p 'What file would you like to use?' f
read -p 'What file number??' columncount

columncount=$((${columncount}+1))

###Generate hybrids


mkdir /home/davids/subsampled_minION_data/${coverage}
name=${f%.*}
name=${name%.*}
name=$(basename $name)
echo ${name}
mean_read_length=$(cat /home/davids/NanoStats/raw_minION_fastq/mean_read_length_column | head -n ${columncount}| tail -n 1)
echo ${mean_read_length}
echo ${coverage}
echo ${genome_size}
num_reads=$(echo ${genome_size}*${coverage} | bc)
num_reads=$(echo ${num_reads}/${mean_read_length} | bc)
num_reads=$(echo ${num_reads} | awk '{print int($1+0.5)}')
echo ${num_reads}
counter=1
mkdir /home/davids/subsampled_minION_data/${coverage}/${name}
while [  $counter -lt 101 ]; do
	echo 'counter ' ${counter}
	echo 'file ' ${f}
	echo 'number of reads '${num_reads}
	echo 'subsampling'
	seqtk sample -s${counter} ${f} ${num_reads} | gzip > /home/davids/subsampled_minION_data/${coverage}/${name}/${name}'_'${coverage}'_'${counter}.fastq.gz
	let counter=counter+1
	done

mkdir /home/davids/NanoStats/${coverage}

	### Quality control
for m in /home/davids/subsampled_minION_data/${coverage}/${name}/*.fastq.gz; do
        s_name=${m%.*}
       	s_name=${s_name%.*}
        s_name=$(basename $s_name)
	echo 'Nanostatting ' ${s_name}
	NanoStat --fastq ${m} > /home/davids/NanoStats/${coverage}/${s_name}.txt
	done

mash sketch -p 4 -o /home/davids/mash/${coverage}${name}.msh /home/davids/subsampled_minION_data/${coverage}/${name}/*.fastq.gz
rm -rf /home/davids/subsampled_minION_data/${coverage}/${name}


printf '%s\n' ${heading} | paste -sd '' >> /home/davids/NanoStats/'samples'${coverage}'x'.csv

for f in /home/davids/NanoStats/${coverage}/*.txt; do
	name=${f%.*}
        name=$(basename $name)
	echo 'accessing reads' ${name}
	awk -F':' '{print $2}' ${f} > /home/davids/NanoStats/temp
	mean_read_length=$(cat /home/davids/NanoStats/temp | head -n 2 | tail -n 1 | sed 's/\,//g')
	mean_read_quality=$(cat /home/davids/NanoStats/temp | head -n 3 | tail -n 1 | sed 's/\,//g')
	median_read_length=$(cat /home/davids/NanoStats/temp | head -n 4 | tail -n 1 | sed 's/\,//g')
        median_read_quality=$(cat /home/davids/NanoStats/temp | head -n 5 | tail -n 1 | sed 's/\,//g')
	num_reads=$(cat /home/davids/NanoStats/temp | head -n 6 | tail -n 1 | sed 's/\,//g')
        num_bases=$(cat /home/davids/NanoStats/temp | head -n 8 | tail -n 1 | sed 's/\,//g')
	rm -f /home/davids/NanoStats/temp
	printf '%s\n' ${name} ',' ${mean_read_length} ',' ${mean_read_quality} ',' ${median_read_length} ',' ${median_read_quality} ',' ${num_reads} ',' ${num_bases} | paste -sd '' >> /home/davids/NanoStats/'samples'${coverage}'x'.csv
	done

