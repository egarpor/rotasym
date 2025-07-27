
## Retrieve data from http://fenyi.solarobs.csfk.mta.hu

# The sources are the Debrecen Photoheliographic Data (DPD, from 1974 onwards)
# sunspot catalogue and the Greenwich Photoheliographic Results (GPR, from
# 1872 to 1976). The curated data ("final complete") spans from 2005 to 2015
# (as of Dec 2018)

# Download the files GPR1872.txt to GPR1973.txt and DPD1974.txt to DPD2018.txt
# to the /rawdata directory
dir.create("rawdata")
years <- 1872:2018
for (year in years) {

  catalogue <- ifelse(year >= 1974, "DPD", "GPR")
  file_year <- paste0(catalogue, year, ".txt")
  url_year <- paste0("http://fenyi.solarobs.csfk.mta.hu/ftp/pub/", catalogue,
                     "/data/", file_year)
  download.file(url = url_year, destfile = paste0("rawdata/", file_year))

}

# Read all the available data in fixed column format
sun <- NA
widths <- c(1, 5, rep(3, 5), 7, rep(6, 5), rep(7, 5))
for (year in years) {

  file_year <- paste0("rawdata/", ifelse(year >= 1974, "DPD", "GPR"),
                      year, ".txt")
  sun <- rbind(sun, read.fwf(file = file_year, widths = widths))
  cat(year, "\n")

}

# Remove NAs
sun <- sun[-1, ]
sun[sun == 999999] <- NA

# Partition dataset, since the columns have different meanings. The codes
# are as follows:
# - "d": observations per "day" (disregarded)
# - "g": observations referred to sunspot "groups"
# - "s": observations referred to individual "sunspot"
sun_g <- subset(sun, subset = V1 == "g")
sun_s <- subset(sun, subset = V1 == "s")
# rm(sun)

# Names for columns
names(sun_g) <- c("code", "year", "month", "day", "hour_UT", "minute_UT",
                  "second_UT", "NOAA", "spot_number", "total_umbrae_area",
                  "total_whole_area", "total_corr_umbrae_area",
                  "total_corr_whole_area", "w_mean_helio_lat_B",
                  "w_mean_helio_long_L", "w_mean_longitudinal_dist_LCM",
                  "w_mean_position_angle", "w_mean_dist_center_sun_disc")
names(sun_s) <- c("code", "year", "month", "day", "hour_UT", "minute_UT",
                  "second_UT", "NOAA", "spot_number", "umbrae_area",
                  "whole_area", "corr_umbrae_area", "corr_whole_area",
                  "helio_lat_B", "helio_long_L", "longitudinal_dist_LCM",
                  "position_angle", "dist_center_sun_disc")

# Remove spaces and cast to factors
sun_g$NOAA <- as.factor(gsub(pattern = " ", replacement = "", x = sun_g$NOAA))
sun_s$NOAA <- as.factor(gsub(pattern = " ", replacement = "", x = sun_s$NOAA))

# Change character variables to numeric
numeric_vars <- c(2:7, 9:18)
sun_g[, numeric_vars] <- apply(sun_g[, numeric_vars], 2, as.numeric)
sun_s[, numeric_vars] <- apply(sun_s[, numeric_vars], 2, as.numeric)

## Add solar cycles information

# List of of the beginning of solar cycles
cycles <- data.frame(
  year = c(1755, 1766, 1775, 1784, 1798, 1810, 1823, 1833, 1843, 1855, 1867,
           1878, 1890, 1902, 1913, 1923, 1933, 1944, 1954, 1964, 1976, 1986,
           1996, 2008, Inf),
  month = c(3, 6, 6, 9, 4, 8, 5, 11, 7, 12, 3, 12, 3, 1, 7, 8, 9, 2, 4, 10,
            3, 9, 8, 12, Inf)
)

# Function to add solar cycles to data
solar_cycle <- function(num_cycle, data) {

  begin <- cycles[num_cycle, ]
  end <- cycles[num_cycle + 1, ]
  year_from <- cycles$year[num_cycle]
  month_from <- cycles$month[num_cycle]
  year_to <- cycles$year[num_cycle + 1]
  month_to <- cycles$month[num_cycle + 1]
  with(data, ((year > year_from) | (year == year_from & month >= month_from)) &
         ((year < year_to) | (year == year_to & month < month_to)))

}

# Add cycles
sun_g$cycle <- NA
sun_s$cycle <- NA
for (s in 1:(nrow(cycles) - 1)) {

  sun_g$cycle[solar_cycle(num_cycle = s, data = sun_g)] <- s
  sun_s$cycle[solar_cycle(num_cycle = s, data = sun_s)] <- s

}

# Save as .RDatas
save(list = "sun_g", file = "sun_g.RData")
save(list = "sun_s", file = "sun_s.RData")

# Remove .txt files and directory -- all the information saved on .RDatas
file.remove(dir(path = "rawdata", pattern = "*.txt", full.names = TRUE))
unlink("rawdata", recursive = TRUE)

## Preprocess the grouped data

# For date operations
library(lubridate)

# Load data in case it was not
load("sun_g.RData")
load("sun_s.RData")

# Remove records with NAs in the angles
sun_g_bd <- sun_g[complete.cases(sun_g$w_mean_helio_lat_B,
                                 sun_g$w_mean_helio_long_L), ]
sun_s_bd <- sun_s[complete.cases(sun_s$helio_lat_B,
                                 sun_s$helio_long_L), ]

# Add year date with day precision
sun_g_bd$date <-
  ymd_hms(paste(paste(sun_g_bd$year, sun_g_bd$month,
                      sun_g_bd$day, sep = "-"),
              paste(sun_g_bd$hour_UT, sun_g_bd$minute_UT,
                    sun_g_bd$second_UT, sep = ":")))
sun_s_bd$date <-
  ymd_hms(paste(paste(sun_s_bd$year, sun_s_bd$month,
                      sun_s_bd$day, sep = "-"),
                paste(sun_s_bd$hour_UT, sun_s_bd$minute_UT,
                      sun_s_bd$second_UT, sep = ":")))

# Remove records with NAs in the date
sun_g_bd <- sun_g_bd[!is.na(sun_g_bd$date), ]
sun_s_bd <- sun_s_bd[!is.na(sun_s_bd$date), ]

# Take only the "births" of the sunspots -- the first recorded observation
# for each NOAA sunspot group number. Warning: NOAA numbers can be repeated
# without corresponding to the same sunspot group (e.g., NOAA 8073 appears
# in 1917 and 1997):
# plot(sun_g_bd$date, as.integer(as.character(sun_g_bd$NOAA)))
# It seems that in 1974 the NOAA counter was restarted (probably
# because of the change in the data source -- DPD was employed from 1974
# onward; GPR before 1974)

# Append to the NOAAA field from GPR the prefix "GPR" to distinguish from the
# DPD observations
sun_g_bd$NOAA <- as.character(x = sun_g_bd$NOAA)
sun_g_bd$NOAA[sun_g_bd$year < 1974] <-
  paste0("GPR", sun_g_bd$NOAA[sun_g_bd$year < 1974])
sun_g_bd$NOAA <- as.factor(sun_g_bd$NOAA)
sun_s_bd$NOAA <- as.character(x = sun_s_bd$NOAA)
sun_s_bd$NOAA[sun_s_bd$year < 1974] <-
  paste0("GPR", sun_s_bd$NOAA[sun_s_bd$year < 1974])
sun_s_bd$NOAA <- as.factor(sun_s_bd$NOAA)

# Skip repeated data safely to have only the births and deaths for groups of
# sunspots. Cannot track the birth/death of individual sunspots because the spot
# number field is assigned arbitrarily between one day and the next, so it is
# not tracking individual sunspots (cf. "The numbering of spots was made
# arbitrarily on each series of observation, thus, the number of a specific
# spot usually changes from one day to the next." from
# http://fenyi.solarobs.epss.hun-ren.hu/ftp/pub/DPD/README.txt). Hence the first
# appearance of sunspot number 3 might be related to the third time the sunspot
# number 1 was observed. Also, the last observation of sunspot number 6 might be
# happen before the last observation of sunspot number 5, but sunspot number 6
# would be assigned label 5 when the sunspot number 5 is not observed anymore.
# In the sunspot number field there never is a series of records with gaps, like
# "1, 5, 6" indicating that spots 2, 3, 4 died; rather, the record would be
# "1, 2, 3" due to relabeling.
births_g <- sun_g_bd[!duplicated(sun_g_bd$NOAA), ]
deaths_g <- sun_g_bd[!rev(duplicated(rev(sun_g_bd$NOAA))), ]

# Compute (theta, phi) angles simpler to interpret
births_g$theta <- births_g$w_mean_helio_long_L / 360 * 2 * pi
births_g$phi <- births_g$w_mean_helio_lat_B / 180 * pi
deaths_g$theta <- deaths_g$w_mean_helio_long_L / 360 * 2 * pi
deaths_g$phi <- deaths_g$w_mean_helio_lat_B / 180 * pi

# Save larger datasets
save("births_g", file = "births_g.rda", compress = "bzip2")
save("deaths_g", file = "deaths_g.rda", compress = "bzip2")

# Save a smaller object with the most important information, the one included
# in rotasym

# Sunspots
sunspots_births <- subset(births_g,
                          select = c("NOAA", "date", "cycle",
                                     "total_corr_whole_area",
                                     "w_mean_dist_center_sun_disc",
                                     "theta", "phi"))
sunspots_deaths <- subset(deaths_g,
                          select = c("NOAA", "date", "cycle", 
                                     "total_corr_whole_area",
                                     "w_mean_dist_center_sun_disc",
                                     "theta", "phi"))
names(sunspots_births)[4:5] <- names(sunspots_deaths)[4:5] <-
  c("total_area", "dist_sun_disc")
save(list = "sunspots_births", file = "sunspots_births.rda",
     compress = "bzip2")
save(list = "sunspots_deaths", file = "sunspots_deaths.rda",
     compress = "bzip2")
