data2018 <- readRDS("data/PINCommEngData (2).RData")

data2018_primary <- data2018 %>%
  mutate(Collectors = str_sub(Collectors, start = 1, end = 3))

data2018_primary$SampleDatetime <- as.POSIXct(data2018_primary$SampleDatetime, format = "%m/%d/%Y %H:%M:%S")

data2018_primary$Date <- as.Date(data2018_primary$SampleDatetime)
data2018_primary$Time <- format(data2018_primary$SampleDatetime, format = "%H:%M:%S")

