#!/bin/bash

# monterey park crime pdfs in data/*

perl convertData.pl
cat data/*.txt > all_crime_data.txt

rm data/*.txt

# remove extraneous info and convert multispaces to comma for a csv file
perl -e 'print "CaseAddress,CaseNumber,CaseReport_DateTime,CaseOffenseStatute,CaseAssignmentType\n"' > all_crime_data.csv

perl -F'\s{2,}' -lane 'if(!/^\s*$/ && !/case/i && $#F > 1){s/\s{2,}/,/g; print}' all_crime_data.txt >> all_crime_data.csv

# save unique addresses to crimeAddress.txt
# copy and paste these addresses to google sheets or something to geocode into lat/long
awk -F, 'NR > 1{print $1}' all_crime_data.csv | sort -k1 | uniq > crimeAddresses.txt
