#setwd('C:/Users/torob/Downloads/MPK_Crime_stats/')
library('data.table')
library('htmlwidgets')
library('leaflet')

crime = fread('all_crime_data.csv')
DateTime = strptime(crime$CaseReport_DateTime, "%m/%d/%Y%t%R");
crime$Date = as.IDate(DateTime)
crime$Time = as.ITime(DateTime)

# unique crime addresses fed into google
uniqAddressGoogle = fread('crimeAddressesGoogleReturn.txt')

#strip out Monterey Park, CA
uniqAddressGoogle$CaseAddress = gsub(',.+$','',uniqAddressGoogle$Address, perl = TRUE)

# splitting out latitude and longitude
uniqAddressGoogle$lat = as.numeric(sapply(strsplit(uniqAddressGoogle$Coordinates,','),"[[",1))
uniqAddressGoogle$lon = as.numeric(sapply(strsplit(uniqAddressGoogle$Coordinates,','),"[[",2))

# setting keys for merging latitude and longitude w/ unique address
setkey(uniqAddressGoogle,'CaseAddress')
setkeyv(crime, c('CaseAddress','CaseAssignmentType','Date','Time'));
crimeSummary = crime[,.(Count = .N,
                        Date = last(Date),
                        Time = last(Time),
                        CaseNumber = last(CaseNumber)), by = c('CaseAddress','CaseAssignmentType')]
crimeSummary = merge(crimeSummary, uniqAddressGoogle[,.SD,.SDcols = c("CaseAddress","lat","lon")]);

# getting into html format?
crimeSummary[,AssignmentTypeCount := paste("<b> ",CaseAssignmentType, " : </b>", Count)]
crimeSummaryMap = crimeSummary[,.(popup = paste(AssignmentTypeCount,collapse = "<br>"),
                                  Date = last(Date),
                                  Time = last(Time),
                                  CaseNumber = last(CaseNumber),
                                  lat = last(lat),
                                  lon = last(lon)), by = CaseAddress]


# get date
mpkCrimeMap = leaflet(data = crimeSummaryMap) %>%
  addProviderTiles(
    "OpenStreetMap",
    # give the layer a name
    group = "OpenStreetMap"
  ) %>% 
  addMarkers(lat = crimeSummaryMap$lat,
             lng = crimeSummaryMap$lon,
             popup = paste("<b> ADDRESS : </b>", crimeSummaryMap$CaseAddress,
                           "<br>","<b> Last Crime Date : </b>", crimeSummaryMap$Date,
                           "<br>","<b> Last Crime Case : </b>", crimeSummaryMap$CaseNumber,
                           "<br>", crimeSummaryMap$popup))

# save the map.
saveWidget(mpkCrimeMap, 'mpkCrimeMap.html')
