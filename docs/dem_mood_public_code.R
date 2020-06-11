### Code to create public democratic mood dataset

# working directory

WD = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(WD))
print( getwd() )

draws = read.csv("supdem_draws_postPA_mod5.csv")
pe = read.csv("supdem_est_postPA_mod5_v3.csv")

head(pe)
summary(pe)
names(draws)
dim(pe)
dim(draws)

# merge
draws = draws[, 1:103]
supdem = merge(pe, draws, by=c("Country", "Year"), all=TRUE)
names(supdem)

# rename variables
supdem$ISOCode.y = NULL
supdem = plyr::rename(supdem, c(ISOCode.x = "ISO_code"))
supdem = plyr::rename(supdem, c(theta = "Dem_mood"))

# check missing
table(factor(supdem$Country))
table(factor(supdem$ISO_code))

supdem$ISO_code[supdem$Country=="Taiwan"] = "TWN"

# remove pre-first year data
cnts = supdem[supdem$Year==2008, "ISO_code"]
frst.yr = supdem[supdem$Year==2008, "First_yr"]
for(i in 1:length(cnts)) {
  supdem[supdem$ISO_code==cnts[i] & supdem$Year<frst.yr[i], "Dem_mood"] = NA
}
sort(by(supdem$Dem_mood, supdem$Country, function(x) sum(!is.na(x))))

supdem = supdem[!(is.na(supdem$Dem_mood)),]

# clean up
supdem$First_yr = NULL
summary(supdem)

write.csv(supdem, "dem_mood_v2.csv", row.names=FALSE)
