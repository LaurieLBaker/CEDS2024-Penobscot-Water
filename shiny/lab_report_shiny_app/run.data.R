data2018 <- readRDS("data/PINCommEngData (2).RData")

data2018_primary <- data2018 %>%
  mutate(Collectors = str_sub(Collectors, start = 1, end = 3))

data2018_primary$SampleDatetime <- as.POSIXct(data2018_primary$SampleDatetime, format = "%m/%d/%Y %H:%M:%S")

data2018_primary$Date <- as.Date(data2018_primary$SampleDatetime)
data2018_primary$Time <- format(data2018_primary$SampleDatetime, format = "%H:%M:%S")

transport_temp <- read.table("data/c_FieldTransportTemps.txt",
                             header = TRUE,
                             sep = ",")

containers <- read.table("data/0_ContainerMgmt.txt",
                         header = TRUE,
                         sep = ",")

# trans_temp_2018 <- transport_temp %>%
#   mutate(Rundate = as.character(RunDate)) %>%
#   mutate(RunYear = str_sub(RunDate, start = 6, end = 9)) %>%
#   filter(RunYear == "2018")
# 
# data_transp <- data2018_primary %>%
#   mutate(RunDate = as.character(RunDate)) %>%
#   left_join(transport_temp, by = join_by(RunCode == RunCode, RunDate == RunDate, SiteCode == SiteCode), keep = TRUE, relationship = "many-to-many") %>%
#   select(!RunDate.y, !RunCode.y, !SiteCode.y) %>%
#   rename(RunCode = RunCode.x,
#          RunDate = RunDate.x,
#          SiteCode = SiteCode.x)
# 
# data_2018_all <- data_transp %>%
#   left_join(containers, by = join_by(CntrType == CntrType, CntrColor == CntrColor, CntrVol == CntrVol, SampleFilterMethod == SampleFilterMethod, ContainerCode == ContainerCode, ContainerAbbrev == ContainerAbbrev)) %>%
#   select(!RunDate.y, !RunCode.y, !SiteCode.y)

