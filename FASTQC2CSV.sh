#!/bin/bash


for f in /media/dave/minION_Dave/FASTQC_CC_everything/*; do
	name=$(awk 'NR==4' ${f}/fastqc_data.txt)
	sequences=$(awk 'NR==7' ${f}/fastqc_data.txt)
	printf '%s\n' ${name} ',' ${sequences} | paste -sd '' >> /media/dave/minION_Dave/FASTQC_CC_everything/FASTQC.csv
	done
exit
