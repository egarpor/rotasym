

#' @title Recorded sunspots births/deaths during 1872--2018
#'
#' @description Processed version of the
#' \href{http://fenyi.solarobs.epss.hun-ren.hu/DPD/}{
#' Debrecen Photoheliographic Data (DPD)} sunspot catalog and the
#' revised version of the
#' \href{http://fenyi.solarobs.epss.hun-ren.hu/GPR/}{
#' Greenwich Photoheliographic Results (GPR)} sunspot catalog. The two
#' sources contain the records of sunspots appeared during 1872--2018 (GPR for
#' 1872--1976; DPD for 1974--2018).
#'
#' Sunspots appear in groups and have a variable lifetime. This dataset has
#' been processed to account for the \emph{births} (first observations) and
#' \emph{deaths} (last observations) of \emph{groups} of sunspots.
#'
#' @docType data
#' @format A data frame with 51303 rows and 6 variables:
#' \describe{
#'   \item{NOAA}{NOAA identifier of the group of sunspots, a factor.}
#'   \item{date}{UTC date, as \code{\link[base:DateTimeClasses]{POSIXct}}, of
#'   the first observation of a group of sunspots.}
#'   \item{cycle}{\href{https://en.wikipedia.org/wiki/List_of_solar_cycles}{
#'   solar cycle} in which the group of sunspots was observed.}
#'   \item{total_area}{total whole spot area of the group, measured in
#'   millionths of the solar hemisphere.}
#'   \item{dist_sun_disc}{distance from the center of Sun's disc, measured in
#'   units of the solar radius.}
#'   \item{theta}{mean longitude angle \eqn{\theta \in [0, 2\pi)} of the
#'   group position.}
#'   \item{phi}{mean latitude angle \eqn{\phi \in [-\pi/2, \pi/2)} of the
#'   group position.}
#' }
#' @details
#' The mean position of the group of sunspots is obtained by a weighted average
#' of the positions of the single sunspots by the whole spot area of the
#' single spots. The areas are corrected to account for foreshortening.
#'
#' The \eqn{(\theta, \phi)} angles are such their associated Cartesian
#' coordinates are:
#' \deqn{(\cos(\phi) \cos(\theta), \cos(\phi) \sin(\theta), \sin(\phi)),}{
#' (cos(\phi) cos(\theta), cos(\phi) sin(\theta), sin(\phi)),}
#' with \eqn{(0, 0, 1)} denoting the north pole.
#'
#' The DPD data has
#' \href{http://fenyi.solarobs.epss.hun-ren.hu/ftp/pub/DPD/README.txt}{
#' different states} of completeness and quality control. The
#' longest span of "final complete data" (no missing observation days and
#' the data has undergone a systematic quality control) is from 2005 to 2015.
#'
#' The data has been preprocessed using the following pipeline:
#' \enumerate{
#'   \item Retrieve data from the GPR and DPD sunspot catalogs.
#'   \item Omit observations with \code{NA}s in the sunspot positions.
#'   \item Filter for sunspot groups.
#'   \item Relabel the NOAA identifier for the sunspot group for records
#'   before 1974, prefixing the "GPR" string. Otherwise, very different groups
#'   of sunspots from the two catalogs may share the same identifier.
#'   \item Keep only the first row of each NOAA instance, the first-ever
#'   observation of each sunspot group.
#' }
#' The script performing the preprocessing is available at
#' \href{https://github.com/egarpor/rotasym/blob/master/data-raw/sunspots.R}{
#' \code{sunspots.R}}
#' @source \url{http://fenyi.solarobs.epss.hun-ren.hu}
#' @author Data processed by Eduardo García-Portugués, Davy Paindaveine, and
#' Thomas Verdebout from the original sources.
#' @references
#' Baranyi, T., Győri, L., Ludmány, A. (2016) On-line tools for solar data
#' compiled at the Debrecen observatory and their extensions with the
#' Greenwich sunspot data. \emph{Solar Physics}, 291(9--10):3081--3102.
#' \doi{10.1007/s11207-016-0930-1}
#'
#' Győri, L., Ludmány, A., Baranyi, T. (2019) Comparative analysis of Debrecen
#' sunspot catalogues. \emph{Monthly Notices of the Royal Astronomical
#' Society}, 465(2):1259--1273. \doi{10.1093/mnras/stw2667}
#' @examples
#' # Load births data of the 23rd cycle
#' data("sunspots_births")
#' sp_bir_23 <- subset(sunspots_births, cycle == 23)
#'
#' # Transform to Cartesian coordinates
#' sp_bir_23$X_bir <-
#'   cbind(cos(sp_bir_23$phi) * cos(sp_bir_23$theta),
#'         cos(sp_bir_23$phi) * sin(sp_bir_23$theta),
#'         sin(sp_bir_23$phi))
#'
#' # Plot births
#' n_cols <- 100
#' cuts <- cut(x = sp_bir_23$date, include.lowest = TRUE,
#'             breaks = quantile(sp_bir_23$date,
#'                               probs = seq(0, 1, l = n_cols + 1)))
#' scatterplot3d::scatterplot3d(sp_bir_23$X_bir, xlim = c(-1, 1),
#'                              ylim = c(-1, 1), zlim = c(-1, 1),
#'                              color = viridisLite::viridis(n_cols)[cuts],
#'                              pch = 16, cex.symbols = 0.5, xlab = "",
#'                              ylab = "", zlab = "", angle = 30)
#' # Spörer's law: sunspots at the beginning of the solar cycle (dark blue
#' # color) tend to appear at higher latitudes, gradually decreasing to the
#' # equator as the solar cycle advances (yellow color)
#'
#' # Estimation of the density of the cosines
#' V <- cosines(X = sp_bir_23$X_bir, theta = c(0, 0, 1))
#' h <- bw.SJ(x = V, method = "dpi")
#' plot(kde <- density(x = V, bw = h, n = 2^13, from = -1, to = 1), col = 1,
#'      xlim = c(-1, 1), ylim = c(0, 3), axes = FALSE, main = "",
#'      xlab = "Cosines (latitude angles)", lwd = 2)
#' at <- seq(-1, 1, by = 0.25)
#' axis(2); axis(1, at = at)
#' axis(1, at = at, line = 1, tick = FALSE,
#'      labels = paste0("(", 90 - round(acos(at) / pi * 180, 1), "º)"))
#' rug(V)
#' legend("topright", legend = c("Full cycle", "Initial 25% cycle",
#'                               "Final 25% cycle"),
#'        lwd = 2, col = c(1, viridisLite::viridis(12)[c(3, 8)]))
#'
#' # Density for the observations within the initial 25% of the cycle
#' part1 <- sp_bir_23$date < quantile(sp_bir_23$date, 0.25)
#' V1 <- cosines(X = sp_bir_23$X[part1, ], theta = c(0, 0, 1))
#' h1 <- bw.SJ(x = V1, method = "dpi")
#' lines(kde1 <- density(x = V1, bw = h1, n = 2^13, from = -1, to = 1),
#'       col = viridisLite::viridis(12)[3], lwd = 2)
#'
#' # Density for the observations within the final 25% of the cycle
#' part2 <- sp_bir_23$date > quantile(sp_bir_23$date, 0.75)
#' V2 <- cosines(X = sp_bir_23$X[part2, ], theta = c(0, 0, 1))
#' h2 <- bw.SJ(x = V2, method = "dpi")
#' lines(kde2 <- density(x = V2, bw = h2, n = 2^13, from = -1, to = 1),
#'       col = viridisLite::viridis(12)[8], lwd = 2)
#'
#' # Computation the level set of a kernel density estimator that contains
#' # at least 1 - alpha of the probability (kde stands for an object
#' # containing the output of density(x = data))
#' kde_level_set <- function(kde, data, alpha) {
#'
#'   # Estimate c from alpha
#'   c <- quantile(approx(x = kde$x, y = kde$y, xout = data)$y, probs = alpha)
#'
#'   # Begin and end index for the potentially many intervals in the level sets
#'   kde_larger_c <- kde$y >= c
#'   run_length_kde <- rle(kde_larger_c)
#'   begin <- which(diff(kde_larger_c) > 0) + 1
#'   end <- begin + run_length_kde$lengths[run_length_kde$values] - 1
#'
#'   # Return the [a_i, b_i], i = 1, ..., K in the K rows
#'   return(cbind(kde$x[begin], kde$x[end]))
#'
#' }
#'
#' # Level set containing the 90% of the probability, in latitude angles
#' 90 - acos(kde_level_set(kde = kde, data = V, alpha = 0.10)) / pi * 180
#'
#' # Modes (in cosines and latitude angles)
#' modes <- c(kde$x[kde$x < 0][which.max(kde$y[kde$x < 0])],
#'            kde$x[kde$x > 0][which.max(kde$y[kde$x > 0])])
#' 90 - acos(modes) / pi * 180
#'
#' # Load deaths data of the 23rd cycle
#' data("sunspots_deaths")
#' sp_dea_23 <- subset(sunspots_deaths, cycle == 23)
#'
#' # Transform to Cartesian coordinates
#' sp_dea_23$X_dea <-
#'   cbind(cos(sp_dea_23$phi) * cos(sp_dea_23$theta),
#'         cos(sp_dea_23$phi) * sin(sp_dea_23$theta),
#'         sin(sp_dea_23$phi))
#'
#' # Match births and deaths, and exclude single-day observations
#' sp_23 <- dplyr::full_join(sp_bir_23, sp_dea_23, by = "NOAA",
#'                           suffix = c("_bir", "_dea"))
#' sp_23 <- sp_23[sp_23$date_bir != sp_23$date_dea, ]
#'
#' # Plot births and deaths associated to the 23rd cycle, and color according
#' # to movement direction of sunspots
#' sc <- scatterplot3d::scatterplot3d(sp_23$X_bir, xlim = c(-1, 1),
#'                                    ylim = c(-1, 1), zlim = c(-1, 1),
#'                                    color = 1, cex.symbols = 0.1,
#'                                    pch = 16, xlab = "", ylab = "", zlab = "",
#'                                    angle = 30)
#' sc$points3d(sp_23$X_dea, col = 1, cex = 0.1)
#' for (i in seq_len(nrow(sp_23))) {
#'   sc$points3d(rbind(sp_23$X_bir[i, ], sp_23$X_dea[i, ]),
#'               col = ifelse((sp_23$theta_bir[i] - sp_23$theta_dea[i]) %%
#'                             (2 * pi) < pi, 2, 3), type = "l")
#' }
#' @name sunspots


#' @rdname sunspots
"sunspots_births"


#' @rdname sunspots
"sunspots_deaths"
