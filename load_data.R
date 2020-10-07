# Read dataset and wrangle

## Read the latest file ----
fils <- list.files("data/")
latest <- fils[order(format(as.Date(substr(fils, 1, 10), format = "%Y-%m-%d")), decreasing = T)[1]]
d <- readr::read_csv2(paste0("data/", latest))
# d <- readr::read_csv2("./data/2020-10-05_clinical_trials.csv") ## manual file read

## Wrangle variables ----
# Use commas
d$`Therapy Area` <- gsub(pattern = "\n", replacement = ", ", x = d$`Therapy Area`)
d$Country <- gsub(pattern = "\n", replacement = ", ", x = d$Country)
d$`Sponsor Name` <- gsub(pattern = "\n", replacement = ", ", x = d$`Sponsor Name`)
d$Indication <-  iconv(d$Indication, from = "latin1", to = "UTF-8")
d$Indication <- gsub(pattern = "\n", replacement = ", ", x = d$Indication)
# dates
d$`Trial Start Date` <- as.Date(d$`Trial Start Date`, "%d-%b-%Y")
d$`Trial End Date` <- as.Date(d$`Trial End Date`, "%d-%b-%Y")
# factors
d$`Trial Status` <- factor(d$`Trial Status`)
d$`Trial Phase` <- factor(d$`Trial Phase`)
# Create URL link
d$url <- paste0("trials/", d$`Trial Identifier`, ".html")
d$Link <- paste0("<a href='",d$url,"'>",d$url,"</a>")

