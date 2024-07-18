setwd("~/Desktop/203A_DataManagement/Lab5")
justices<-read.csv("supreme_court_justices.csv", sep=",", header = TRUE)

typeof(justices)
class(justices)
names(justices)
head(justices)

justices$birdate <- as.Date(justices$birdate, "%m/%d/%Y")
typeof(justices$birdate)
head(justices$birdate,10)

nom_date <- paste("07","01",justices$yrnom, sep="/")
justices$nomdate <- as.Date(nom_date, "%m/%d/%Y")
head(justices)

justices$nomage <- as.numeric(round((justices$nomdate - justices$birdate)/365.25))
mean(justices$nomage, na.rm = T)

#1
justices$deathd <- as.Date(justices$deathd, "%m/%d/%Y", na.rm=T)
typeof(justices$deathd)
head(justices$deathd,10)

justices$birdate <- as.Date(justices$birdate, "%m/%d/%Y", na.rm=T)
tail(justices)

justices$deathage <- as.numeric(round((justices$deathd - justices$birdate)/365.25))
mean(justices$deathage, na.rm = T)

#2
justices[50,c("name")]

justices[-c(1:174),c("name")]

justices[100,c("birdate")]

justices$name[125]


#3
just <- justices[justices$success == 1,]
mean(just$nomage, na.rm = T)
median(just$nomage, na.rm = T)


asso_just <- justices[justices$posit == 1,]
mean(asso_just$nomage, na.rm = T)
median(asso_just$nomage, na.rm = T)


prior <- justices[justices$yrnom < 1900,]
mean(prior$nomage, na.rm = T)
median(prior$nomage, na.rm = T)


after <- justices[justices$yrnom >= 1900,]
mean(after$nomage, na.rm = T)
median(after$nomage, na.rm = T)

#4
youngest <- justices[justices$success == 1,]
min_age=min(youngest$nomage, na.rm=T)
youngest <- youngest[youngest$nomage == min_age,c("name","nomage")]
youngest


oldest <- justices[justices$success == 1,]
max_age=max(oldest$nomage, na.rm=T)
oldest <- oldest[oldest$nomage == max_age,c("name","nomage")]
oldest


ca <- justices[justices$success == 1,]
ca <- ca[ca$birthst == 5, c("name","nomage")]
ca

#5
total_nominations <- nrow(justices)
white_nominations <- sum(justices$race == 0)
white_nominations
white_percentage <- (white_nominations / total_nominations) * 100
white_percentage


not_white <- justices[justices$race != 0, ]
m=min(not_white$nomdate)
not_white <- not_white[not_white$nomdate == m, c("name","yrnom")]
not_white


total_nominations <- nrow(justices)
female <- sum(justices$gender == 1)
female
female_percentage <- (female / total_nominations) * 100
female_percentage


first_female <- justices[justices$gender == 1,]
first_female <- first_female[first_female$nomdate == min(first_female$nomdate), c("name","yrnom")]
first_female


under_middle <- sum(justices$famses == 1 | justices$famses == 2)
percent <- under_middle / nrow(justices)
percent

#6
table(justices$posit,justices$birthst)
just <- justices
birth_state_counts <- table(just$birthst)
max_count <- max(birth_state_counts)
max_count
most_common_birth_states <- names(birth_state_counts[birth_state_counts == max_count])
most_common_birth_states
# 32 is New York



