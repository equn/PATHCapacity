# planning
## schedule data
## id, time_stamp, station_name, line_name, direction_name, service_name, service_type, exception

## planned exceptions
## maybe

## turnstile data
## id, entry, exit, station, date_time

# preperation
setwd("/Users/equn/Dropbox/Class/RClass/PATH/")

# turnstile data cleanup
# https://raw.githubusercontent.com/CodeForJerseyCity/PATHDataJam/gh-pages/data/turnstile_cleaned_2.csv
turnstile <- read.csv("turnstile_cleaned.csv")
turnstile$STATION <- substr(turnstile$STATION,1,3)
turnstile$STATION <- gsub("30t","33r",turnstile$STATION)
turnstile$STATION <- gsub("Wor","WTC",turnstile$STATION)
turnstile$STATION <- gsub("30t","33r",turnstile$STATION)
unique(turnstile$STATION)
write.csv("turnstile_final.csv")


