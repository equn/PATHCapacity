# planning
## schedule data
## id, time_stamp, station_name, line_name, direction_name, service_name, service_type, exception

## planned exceptions
## maybe

## turnstile data
## id, entry, exit, station, date_time

# preperation
setwd("/Users/equn/Dropbox/Class/RClass/PATH/")
library(reshape2)

# turnstile data cleanup
# https://raw.githubusercontent.com/CodeForJerseyCity/PATHDataJam/gh-pages/data/turnstile_cleaned_2.csv
turnstile <- read.csv("turnstile_cleaned.csv")
turnstile$STATION <- substr(turnstile$STATION,1,3)
turnstile$STATION <- gsub("30t","33r",turnstile$STATION)
turnstile$STATION <- gsub("Wor","WTC",turnstile$STATION)
turnstile$STATION <- gsub("30t","33r",turnstile$STATION)
unique(turnstile$STATION)
turnstile$yyyy = substr(turnstile$DATE_TIME,1,4)
turnstile$mm = substr(turnstile$DATE_TIME,6,7)
turnstile$dd = substr(turnstile$DATE_TIME,9,10)
turnstile$h = substr(turnstile$DATE_TIME,12,13)
turnstile$m = substr(turnstile$DATE_TIME,15,16)
turnstile$s = substr(turnstile$DATE_TIME,18,19)
write.csv("turnstile_final.csv")

# schedule data load
# http://www.panynj.gov/path/developers.html
# parsed from GTFS charlie bini
schedule <- read.csv("path_schedule_clean.csv")
schedulex <- colsplit(schedule$departure_time,":",c("h","m","s"))
schedule$h <- schedulex$h
schedule$m <- schedulex$m
schedule$s <- schedulex$s
schedule$
unique(schedule$stop_name)

# subsetting schedule data
schedule2 <- subset(schedule, schedule$service_name == "Yearly Service (Mon-Fri)" & schedule$route_long_name == "Journal Square - 33rd Street" & as.numeric(schedule$h) >= 7 & as.numeric(schedule$h <= 22))

# subsetting turnstile data
turnstile2 <- subset(turnstile, turnstile$h >= 7 & turnstile$h <= 22)