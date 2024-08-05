library("sas7bdat")
setwd("~/Desktop/203A_DataManagement/Lab6")
ods <- read.sas7bdat("drug_overdoses.sas7bdat")
head(ods)

ods <- ods[order(ods$YEAR),]
plot(ods$YEAR)

ods$DATA_DATE <- as.Date(paste(ods$YEAR, ods$MONTH, "01", sep="/"),format='%Y/%B/%d')

ny <- ods[ods$STATE == "NY",]
ny <- ny[order(ny$DATA_DATE),]
plot(ny$DATA_DATE, ny$NUMBER_DRUG_OVERDOSE_DEATHS)

plot(ny$DATA_DATE, ny$NUMBER_DRUG_OVERDOSE_DEATHS, 
     main = "Drug Overdose Deaths per Month\nNew York", 
     xlab = "Year", 
     ylab = "Number of Drug Overdose Deaths",
     col  = "blue")

plot(ny$DATA_DATE, ny$NUMBER_COCAINE_DEATHS, 
     type = "l",
     main = "Cocaine and Heroin Overdose Deaths per Month\nNew York", 
     xlab = "Year", 
     ylab = "Number of Drug Overdose Deaths",
     col  = "red")

lines(ny$DATA_DATE, ny$NUMBER_HEROIN_DEATHS, type="l", lty=2, col="blue")

ylim = c(250,850)

plot(ny$DATA_DATE, ny$NUMBER_COCAINE_DEATHS, 
     type = "l",
     main = "Cocaine and Heroin Overdose Deaths per Month\nNew York", 
     xlab = "Year", 
     ylim = c(250,850),
     ylab = "Number of Drug Overdose Deaths",
     col  = "red")

lines(ny$DATA_DATE, ny$NUMBER_HEROIN_DEATHS, type="l", lty=2, col="blue")

lines(ny$DATA_DATE, ny$NUMBER_HEROIN_DEATHS, type="l", lty='dashed', col="blue")

plot(ny$DATA_DATE, ny$NUMBER_COCAINE_DEATHS, 
     type = "l",
     main = "Cocaine and Heroin Overdose Deaths per Month\nNew York", 
     xlab = "Year", 
     ylim = c(250,850),
     ylab = "Number of Drug Overdose Deaths",
     col  = "red")

lines(ny$DATA_DATE, ny$NUMBER_HEROIN_DEATHS, type="l", lty=2, col="blue")

legend(as.Date("01/01/2017", format="%m/%d/%Y"), 350, 
       legend = c("Cocaine","Heroin"),
       col=c("red","blue"), 
       lty=1:2)


#1
dc <- ods[ods$STATE == "DC",]
dc <- dc[order(dc$DATA_DATE),]

plot(dc$DATA_DATE, dc$NUMBER_NATURAL_OPIOD_DEATHS, 
     type = "o",
     main = "Natural and Synthetic Opiod Deaths in Wasington DC\n(2015-2018)", 
     xlab = "Year", 
     ylim = c(0,300),
     ylab = "Number of Deaths",
     col  = "black")

lines(dc$DATA_DATE, dc$NUMBER_SYNTHETIC_OPIOD_DEATHS, type="o", lty=3, col="red")

legend("topleft",as.Date("01/01/2017", format="%m/%d/%Y"),
       legend = c("Natural Opiods","Synthetic Opiods"),
       col=c("black","red"), 
       lty=1:3)

#position of legend?

#1 end

neweng <- droplevels(ods[ods$STATE %in% c('CT','ME','VT','NH','MA','RI'),])

nodne <- tapply(neweng$NUMBER_DRUG_OVERDOSE_DEATHS,
                neweng$STATE,
                mean, na.rm=T)
nodne
plot(nodne)


plot(nodne, 
     type = "o",
     pch = 16,
     axes = FALSE,
     ann = FALSE)

axis(1, at=1:5, lab = names(nodne))
axis(2)

box()

title (main = "Average Monthly Count of Overdose Deaths by State", col.lab = "black")
title (ylab = "Average Monthly Count of Overdose Deaths", col.lab = "darkturquoise")
title (xlab = "State", col.lab = "forestgreen")


#2
data2 <- droplevels(ods[ods$STATE %in% c('VT','NH','ME','CT','RI'),])

proportion <- tapply(data2$NUMBER_DRUG_OVERDOSE_DEATHS/data2$NUMBER_DEATHS,
                data2$STATE,
                median, na.rm=T)

plot(proportion, 
     type = "p",
     pch = 18,
     col = "red",  
     cex = 2, 
     axes = FALSE,
     ann = FALSE,
     ylim = c(0.00, 0.05) )

axis(1, at=1:5, lab = names(proportion))
axis(2,seq(0.00, 0.05, by = 0.01))

box()

title (main = "Median Overdose Death Proportion by State\nNew England", col.lab = "black")
title (ylab = "Median Monthly Proportion of Overdose Deaths", col.lab = "blue")
title (xlab = "State", col.lab = "blue")

#state name order?
#2 end


barplot(nodne, 
        main="Average Monthly Count of Overdose Deaths by State\nNew England", 
        xlab="State",  
        ylab="Average Monthly Count of Overdose Deaths",
        col = "forestgreen",
        ylim = c(0,1000),
        width = 0.4,
        space = 0.4,
        xlim = c(0,3))
box()

barplot(nodne, 
        main="Average Monthly Count of Overdose Deaths by State\nNew England", 
        ylab="State",  
        xlab="Average Monthly Count of Overdose Deaths",
        col = "forestgreen",
        xlim = c(0,1000),
        width = 0.4,
        space = 0.4,
        ylim = c(0,3),
        horiz = TRUE)
box()

#3

new <- droplevels(ods[ods$STATE %in% c('DC','MD','VA'),])

newmean <- tapply(new$NUMBER_COCAINE_DEATHS/new$NUMBER_DEATHS,
                new$STATE,
                mean, na.rm=T)
newmean

barplot(newmean, 
        main="Average Monthly Percent of Cocaine Deaths by State", 
        ylab="State",  
        xlab="Average Monthly Percent of Cocaine Deaths",
        col = "forestgreen",
        xlim = c(0,0.015),
        width = 0.4,
        space = 0.4,
        horiz = TRUE)
box()

#3 end

library(dplyr)

nd <- ods %>%
  mutate(LOCATION = 1*(STATE %in% c('CT','ME','VT','NH','MA','RI')) + 2*(STATE %in% c('DC','VA','MD')),
         DEATH_PROP_METHADONE = NUMBER_METHADONE_DEATHS/NUMBER_DEATHS) %>%
  filter(YEAR %in% c(2015,2016,2017), LOCATION %in% c(1,2)) %>%
  group_by(LOCATION,YEAR) %>%
  summarize(AVGMETH = mean(DEATH_PROP_METHADONE))

nd

md <- matrix(as.matrix(nd[,3]),nrow = 3,ncol = 2, byrow = FALSE)

colnames(md) <- c("New England","DC Area")
row.names(md) <- c("2015","2016","2017")

md

barplot(md,
        beside = TRUE,
        main = "Mean Proportion Methadone Overdose Deaths\nby Location and Year",
        xlab = "Location",
        ylab = "Mean Proportion Methadone Overdose Deaths",
        col = c("blue","forestgreen","violet"),
        ylim = c(0,0.004))
box()

barplot(md,
        beside = TRUE,
        main = "Mean Monthly Proportion Methodone Overdose Deaths\nby Location and Year",
        xlab = "Location",
        ylab = "Mean Monthly Proportion Methodone Overdose Deaths",
        col = c("blue","forestgreen","violet"),
        ylim = c(0,0.004))
box()

legend("topleft", legend=c("2015","2016","2017"),
       bty="n",
       title = c("Year"), 
       fill=c("blue","forestgreen","violet"))

#4
north <- c('CT', 'DC', 'MD', 'ME', 'NH', 'NY', 'OR', 'RI', 'VT', 'WA')
south <- c('NC', 'NM', 'NV', 'OK', 'SC', 'UT', 'VA', 'WV')

fall   <- c('September', 'October', 'November')
spring <- c('March', 'April', 'May')
winter <- c('December', 'January', 'February')
summer <- c('June', 'July', 'August')

data4 <- ods %>%
  mutate(REGION = 1*(STATE %in% north) + 2*(STATE %in% south),
         SEASON = 1*(MONTH %in% spring) + 2*(MONTH %in% summer) + 3*(MONTH %in% fall) + 4*(MONTH %in% winter),
         PROP = NUMBER_DRUG_OVERDOSE_DEATHS/NUMBER_DEATHS) %>%
  group_by(SEASON,REGION) %>%
  summarize(AVGPROP = mean(PROP))

data4

matrix <- matrix(as.matrix(data4[,3]),nrow = 2,ncol = 4, byrow = FALSE)

colnames(matrix) <- c("Spring","Summer","Fall","Winter")
row.names(matrix) <- c("Northern States","Southern States")

matrix


barplot(matrix,
        beside= TRUE,
        main = "Mean Proportion Drug Overdose Deaths\nby Region and Season",
        xlab = "Season",
        ylab = "Mean Proportion Drug Overdose Deaths",
        col = c("blue","yellow"),
        ylim = c(0.020,0.030),
        xpd = FALSE)
box()

legend("topleft", legend=c("Northern States","Southern States"),
       bty="n",
       title = c("Region"), 
       fill=c("blue","yellow"))


#4 end

cd <- ods %>%
  filter(YEAR %in% c(2015,2016,2017), STATE %in% c('DC','MD','VA')) %>%
  group_by(STATE,YEAR) %>%
  summarize(SUMMETH = sum(NUMBER_METHADONE_DEATHS))

cd

dd <- matrix(as.matrix(cd[,3]),nrow = 3,ncol = 3, byrow = TRUE)

colnames(dd) <- c("2015","2016","2017")
row.names(dd) <- c("DC","MD","VA")

dd

barplot(dd,
        main = "Count of Methadone Overdose Deaths by Year and State\nDC Area",
        xlab = "Year",
        ylab = "Count of Methadone Overdose Deaths",
        col = c("blue","forestgreen","violet"),
        ylim = c(0,4000),
        xlim = c(0,2),
        width = 0.4,
        space = 0.5)
box()
legend("topleft", c("DC","MD","VA"), 
       bty="n", 
       title = "State",
       fill=c("blue","forestgreen","violet"))

#5
opiod <- ods %>%
  filter(YEAR %in% c(2015,2016,2017), STATE == "NC" ) %>%
  group_by(YEAR) %>%
  summarize(natural = sum(NUMBER_NATURAL_OPIOD_DEATHS), synthetic = sum(NUMBER_SYNTHETIC_OPIOD_DEATHS))

opiod

m <- matrix(as.matrix(opiod[,2:3]),nrow = 2,ncol = 3, byrow = TRUE)

colnames(m) <- c("2015","2016","2017")
row.names(m) <- c("Natural","Synthetic")

m

barplot(m,
        beside = FALSE,
        main = "Count of Opiod Overdose Deaths by Year and Opiod Type",
        xlab = "Year",
        ylab = "Count of Opiod Overdose Deaths",
        col = c("blue","grey"),
        ylim = c(0,20000))
box()

legend("topleft", legend=c("Natural","Synthetic"),
       bty="n",
       title = c("Opiod Type"), 
       fill=c("blue","grey"))
