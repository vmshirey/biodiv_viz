###########################################
## Dataset Comparison via iGraph Network ##
## Author: V. Shirey           6/14/2017 ##
##                                       ##
## This is a test script for producing a ##
## network diagram showing populated dwc ##
## field within and across datasets.     ##
###########################################

require(igraph) ## require igraph package
require(data.table) ## require data.table package

## load data about carolina anoles from 
## FMNH and UMMZ.

fmnh <- read.csv("occurrence_raw_FMNH.csv", header=TRUE,
                 sep=",")
ummz <- read.csv("occurrence_raw_UMMZ.csv", header=TRUE,
                 sep=",")

## create dataframe to show variables with
## completely null field values (true)

na_fmnh <- sapply(fmnh, function(x)all(is.na(x)))
na_ummz <- sapply(ummz, function(x)all(is.na(x)))

na_fmnh <- as.data.frame(na_fmnh)
na_ummz <- as.data.frame(na_ummz)

na_fmnh <- setDT(na_fmnh, keep.rownames = TRUE)[]
na_ummz <- setDT(na_ummz, keep.rownames = TRUE)[]

## add new column to na dataframe for connections

na_fmnh <- cbind(a = "occurrence", na_fmnh)
na_ummz <- cbind(a = "occurrence", na_ummz)

## plot igraph network for connections, should be radial

par(mfrow(c(1,1)))
fmnh_net <- graph_from_data_frame(d=na_fmnh)
plot(fmnh_net)

## create dataframe with year and gps for
## temporal and geographic comparisons.

geo_vars <- c("dwc.eventDate", "dwc.month", 
              "dwc.year", "dwc.decimalLatitude", 
              "dwc.decimalLongitude")

geo_fmnh <- fmnh[geo_vars]
geo_ummz <- ummz[geo_vars]

## side by side yearly frequency histogram

par(mfrow=c(2,1))
hist(geo_fmnh$dwc.year, main="FMNH Carolina Anole Annual Collection Frequency", xlab="Year", xlim=c(1880, 2017))
hist(geo_ummz$dwc.year, main="UMMZ Carolina Anole Annual Collection Frequency", xlab="Year", xlim=c(1880, 2017))

## side by side monthly frequency histogram

par(mfrow(c(2,1)))
hist(geo_fmnh$dwc.month, main="FMNH Carolina Anole Seasonality", xlab="Month", xlim=c(0,12))
hist(geo_ummz$dwc.month, main="UMMZ Carolina Anole Seasonality", xlab="Month", xlim=c(0,12))

