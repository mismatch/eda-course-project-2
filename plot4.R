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

getCoalCodes <- function() {
    srcCodes <- readRDS("Source_Classification_Code.rds")
    coalCodesSelector <- grepl("Coal", srcCodes$EI.Sector) & 
        grepl("Combustion", srcCodes$SCC.Level.One)
    coalCodes <- srcCodes$SCC[coalCodesSelector]
}

getNEIByCoalCodes <- function(coalCodes) {
    NEI <- readRDS("summarySCC_PM25.rds")
    NEI[NEI$SCC %in% coalCodes, ]
}

ensureDataDownloaded("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip")
NEI <- getNEIByCoalCodes(getCoalCodes())
aggregatedNEI <- aggregate(Emissions ~ year, data = NEI, sum)

png("plot4.png", width = 480, height = 480)
par(mar  = c(5, 5, 4, 1))

barplot(aggregatedNEI$Emissions, col = "sienna", 
        main = "Total emissions by year\nCoal combustion-related sources", 
        xlab = "Year", ylab = "Emissions, tons", names = aggregatedNEI$year, 
        space = 0.075)

dev.off()