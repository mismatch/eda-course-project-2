ensureDataDownloaded <- function(url) {
    if (file.exists("Source_Classification_Code.rds")
        && file.exists("summarySCC_PM25.rds")) {
        return()
    }
    
    localPath <- "NEI_data.zip"
    download.file(url, destfile = localPath, method = "curl")
    unzip(localPath)
    file.remove(localPath)
}

readSummarySCC <- function() {
    ensureDataDownloaded("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip")
    
    readRDS("summarySCC_PM25.rds")
}

NEI <- readSummarySCC()
NEI <- NEI[NEI$fips == "24510", ]
emissionsByYearAndType <- aggregate(Emissions ~ year + type, data = NEI, sum)

png("plot3.png", width = 800, height = 480)
library(ggplot2)
qplot(year, Emissions, data = emissionsByYearAndType, facets = . ~ type, 
      ylab = "Emissions, tons", main = "Emissions in Baltimore City") + geom_smooth()
dev.off()