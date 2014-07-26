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

getMotorVehicleCodes <- function() {
    srcCodes <- readRDS("Source_Classification_Code.rds")
    motorVehicleCodesSelector <- grepl("[Mm]obile", srcCodes$EI.Sector)
    srcCodes$SCC[motorVehicleCodesSelector]
}

getMotorVehicleEmissions <- function(codes) {
    NEI <- readRDS("summarySCC_PM25.rds")
    NEI[NEI$SCC %in% codes & NEI$fips == "24510", ]
}

ensureDataDownloaded("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip")
NEI <- getMotorVehicleEmissions(getMotorVehicleCodes())
aggregatedNEI <- aggregate(Emissions ~ year, data = NEI, sum)

png("plot5.png", width = 480, height = 480)
par(mar  = c(5, 5, 4, 1))

barplot(aggregatedNEI$Emissions, col = "sienna", 
        main = "Total emissions in Baltimore City\nMotor vehicle-related sources", 
        xlab = "Year", ylab = "Emissions, tons", names = aggregatedNEI$year, 
        space = 0.075)

dev.off()