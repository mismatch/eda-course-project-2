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
emissionsByYear <- aggregate(Emissions ~ year, data = NEI, sum)
emissionsByYear$Emissions = emissionsByYear$Emissions / 1.e6

png("plot1.png", width = 480, height = 480)
par(mar  = c(5, 5, 4, 1))

barplot(emissionsByYear$Emissions, col = "sienna", main = "Total emissions by year", 
        xlab = "Year", ylab = "Emissions, megatons", names = emissionsByYear$year, 
        space = 0.075)

dev.off()