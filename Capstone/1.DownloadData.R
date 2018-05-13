
setwd("C:/datasciencecoursera/Capstone")


destFile <- "Coursera-SwiftKey.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"


if(!file.exists(destFile)){
    res <- download.file(fileURL,
                         destfile=destFile, 
                         method="auto")
    if(res != 0) {
        print("error while downloading file")
        quit(status = 1)
    }
}



unzip(destFile, overwrite = FALSE)