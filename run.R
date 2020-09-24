# Creates clinical trials webpages from CSV file

d <- readr::read_csv2("../data/clinical_trials.csv")

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
  fils <- list.files("output/", full.names = T)
  for (fil in fils) {
    file.remove(fil)
  }
}

## CREATE TRIAL RMD-PAGES -----
for (i in 1:nrow(d)) {
  d1 <- d[i,]
  # read template
  template <- readr::read_file("template.Rmd")
  # replace keywords and description
  template <- stringr::str_replace_all(string = template, 
                                       pattern = "xxx-Trial-Identifier-xxx",
                                       replacement = d1$`Trial Identifier`)
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Title-xxx",
                                       replacement = d1$`Trial Title`)
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Description-xxx",
                                       replacement = d1$`Trial Description`)
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Therapy-Area-xxx",
                                       replacement = d1$`Therapy Area`)
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Status-xxx",
                                       replacement = d1$`Trial Status`)
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Phase-xxx",
                                       replacement = d1$`Trial Phase`)
  
  # template <- stringr::str_replace_all(string = template,
  #                                      pattern = "",
  #                                      replacement = )
  
  # save as new file
  writeLines(template, paste0("./temp/trials/", d1$`Trial Identifier`,".Rmd"))
}


## RENDER TO OUTPUT ----
pages <- list.files("temp/trials/", full.names = T)
for(page in pages){
  # print(page)
  rmarkdown::render(page, output_dir = "output/trials/")
}

## INDEX PAGE ----
rmarkdown::render("index.Rmd", output_dir = "output/")
