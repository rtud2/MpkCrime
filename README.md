## Monterey Park, CA Crime Statistics

A quick and dirty data analysis on Monterey Park, CA crime. Improves on detail provided by the municipality, which just separates crime by 'beat.'
Data provided in pdf format by [Monterey Park, CA website](https://www.montereypark.ca.gov/409/Crime-Statistics)
Geocoding provided by Google Extension `Geocoding by SmartMonkey`

### Steps for Success

1. Use `pdftotext`, `perl`, and `bash` to convert tabular pdf csv. (`dataProcess.sh`)
2. Use `Geocoding by SmartMonkey` to convert unique addresses to lat/long
3. Use `R` to do some data analysis with leaflet.



