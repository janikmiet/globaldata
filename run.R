# Creates clinical trials webpages from CSV file
library(tidyverse)

# Data
d <- readr::read_csv2("../data/clinical_trials.csv")
d$`Therapy Area` <- gsub(pattern = "\n", replacement = ", ", x = d$`Therapy Area`)
d$Country <- gsub(pattern = "\n", replacement = ", ", x = d$Country)
d$`Sponsor Name` <- gsub(pattern = "\n", replacement = ", ", x = d$`Sponsor Name`)

## Create directories 
if(!dir.exists("temp/")) dir.create("temp/")
if(!dir.exists("temp/trials")) dir.create("temp/trials")
if(!dir.exists("output/")) dir.create("output/")
if(!dir.exists("output/trials")) dir.create("output/trials")

## REMOVE ALL FILES FROM ./temp/ -----
if(FALSE){
  fils <- list.files("temp/", full.names = T, recursive = T)
  for (fil in fils) {
    file.remove(fil)
  }
}

## REMOVE ALL FILES FROM output/ -----
if(FALSE){
  fils <- list.files("output/", full.names = T, recursive = T)
  for (fil in fils) {
    file.remove(fil)
  }
}


#help function to chagne na
check_na <- function(x) {
  ifelse(is.na(x), "NA", x)
}

## CREATE TRIAL RMD-PAGES -----
for (i in 1:nrow(d)) {
  d1 <- d[i,]
  
  # read template
  template <- readr::read_file("template.Rmd")
  # replace keywords and description
  template <- stringr::str_replace_all(string = template, 
                                       pattern = "xxx-Trial-Identifier-xxx",
                                       replacement = check_na(d1$`Trial Identifier`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Title-xxx",
                                       replacement = check_na(d1$`Trial Title`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Description-xxx",
                                       replacement = check_na(d1$`Trial Description`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Therapy-Area-xxx",
                                       replacement = check_na(d1$`Therapy Area`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Status-xxx",
                                       replacement = check_na(d1$`Trial Status`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Phase-xxx",
                                       replacement = check_na(d1$`Trial Phase`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Sponsor-Name-xxx",
                                       replacement = check_na(d1$`Sponsor Name`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Sponsor-Type-xxx",
                                       replacement = check_na(d1$`Sponsor Type`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Collaborator-xxx",
                                       replacement = ifelse(is.na(d1$Collaborator), "NA", d1$Collaborator))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Collaborator-Type-xxx",
                                       replacement = ifelse(is.na(d1$`Collaborator Type`), "NA", d1$`Collaborator Type`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Study-Design-xxx",
                                       replacement = ifelse(is.na(d1$`Study Design`), "NA", d1$`Study Design`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Hypothesis-xxx",
                                       replacement = check_na(d1$`Study Hypothesis`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Purpose-xxx",
                                       replacement = check_na(d1$`Purpose`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Primary-Objective-xxx", 
                                       replacement = check_na(d1$`Primary Objective(s)`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Secondary-Objective-xxx",
                                       replacement = check_na(d1$`Secondary Objective(s)`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Responsible-Authority-xxx",
                                       replacement = check_na(d1$`Responsible Authority`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Age-Minimum-xxx",
                                       replacement = check_na(d1$`Age (Minimum Eligibility)`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Age-Maximum-xxx",
                                       replacement = check_na(d1$`Age (Maximum Eligibility)`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Gender-xxx",
                                       replacement = check_na(d1$`Gender`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Healthy-Subject-xxx",
                                       replacement = check_na(d1$`Healthy Subject(s)`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Participants-Criteria-Inclusion-xxx",
                                       replacement = check_na(d1$`Participants Criteria (Inclusion)`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Participants-Criteria-Exclusion-xxx",
                                       replacement = check_na(d1$`Participants Criteria (Exclusion)`))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Subject-Type-xxx",
                                       replacement = check_na(d1$`Subject(s) Type`))
  
  # template <- stringr::str_replace_all(string = template,
  #                                      pattern = "",
  #                                      replacement = )
  
  # save as new file
  writeLines(template, paste0("./temp/trials/", d1$`Trial Identifier`,".Rmd"))
}


## RENDER TO OUTPUT ----
pages <- list.files("temp/trials/", full.names = T)
for(page in pages){
  rmarkdown::render(page, output_dir = "output/trials/")
}

## INDEX PAGE ----
rmarkdown::render("index.Rmd", output_dir = "output/")



## Upload ----

# move files to kapsi
# system("scp -r ./output/* janikmiet@kapsi.fi:sites/janimiettinen.fi/www/clinicaltrials/")

