
# Hexagonal sticker for the 'rotasym' package: an S^2 globe shaded with a
# rotationally symmetric density (magma rings about a tilted axis theta), plus a
# theta axis arrow and a rotation arc. Drawn with a base-graphics orthographic
# ray-caster, then framed by hexSticker.

library(hexSticker)
library(viridisLite)

# Shared logo standards
font <- "Aller_Rg"
name_size <- 31.2
url_size <- 9.0
url_x <- 1.00
url_y <- 0.08
url_angle <- 30
hex_border <- 1.5
dpi <- 600

# Plum hex with an orange border (matching the Python badge palette)
col_fill <- "#2A1339"
col_border <- "#F0812F"
col_title <- "#FCFDBF"
col_url <- "#C9A9CE"
col_axis <- "#FDF4E3"

# Density sphere ray-caster

# Renders the globe as an npix x npix matrix of "#RRGGBBAA" colours: the front
# hemisphere coloured by the density g(theta'x) and Lambert-shaded, transparent
# outside the disk with an anti-aliased rim.
sphere_raster <- function(theta_axis, band0 = 58 * pi / 180, bandsd = 0.20,
                          npix = 1000, light = c(-0.42, 0.55, 0.72),
                          gamma = 0.9, ambient = 0.42, diffuse = 0.68,
                          pal = magma(256, begin = 0.04)) {

  theta_axis <- theta_axis / sqrt(sum(theta_axis^2))
  light <- light / sqrt(sum(light^2))

  # Pixel grid over [-1, 1]^2; rows go top (+y) to bottom (-y)
  grid_x <- seq(-1, 1, length.out = npix)
  grid_y <- seq(1, -1, length.out = npix)
  px_x <- matrix(grid_x, npix, npix, byrow = TRUE)
  px_y <- matrix(grid_y, npix, npix, byrow = FALSE)
  rr <- sqrt(px_x^2 + px_y^2)
  inside <- rr <= 1

  # Front-hemisphere surface normals = unit points on S^2 (view space)
  px_z <- sqrt(pmax(0, 1 - px_x^2 - px_y^2))
  nx <- px_x[inside]; ny <- px_y[inside]; nz <- px_z[inside]

  # Density g(beta): two Gaussian bands about the axis at beta0 and pi - beta0,
  # a function of theta'x alone, so the level sets are rings around the axis.
  tt <- nx * theta_axis[1] + ny * theta_axis[2] + nz * theta_axis[3]
  beta <- acos(pmin(1, pmax(-1, tt)))
  g <- exp(-(beta - band0)^2 / (2 * bandsd^2)) +
    exp(-(beta - (pi - band0))^2 / (2 * bandsd^2))
  s <- (g - min(g)) / (max(g) - min(g) + 1e-12)
  s <- s^gamma
  idx <- pmax(1, pmin(256, 1 + round(s * 255)))

  # Lambert shading from the view-space normal
  shade <- pmin(1, ambient + diffuse *
                  pmax(0, nx * light[1] + ny * light[2] + nz * light[3]))

  base_rgb <- col2rgb(pal[idx])
  red <- pmin(255, round(base_rgb[1, ] * shade))
  green <- pmin(255, round(base_rgb[2, ] * shade))
  blue <- pmin(255, round(base_rgb[3, ] * shade))

  # Anti-aliased rim: fade alpha over the outer ~2.5 px
  edge <- 2.5 / npix
  alpha <- round(255 * pmin(1, pmax(0, (1 - rr[inside]) / edge)))

  cols <- character(npix * npix)
  cols[] <- "#00000000"
  cols[which(inside)] <- rgb(red, green, blue, alpha, maxColorValue = 255)
  matrix(cols, npix, npix)

}

# Compose the globe with the axis arrow and rotation arc

cross3 <- function(a, b) {
  c(a[2] * b[3] - a[3] * b[2],
    a[3] * b[1] - a[1] * b[3],
    a[1] * b[2] - a[2] * b[1])
}

# Filled barbed arrowhead at 2D point `tip` pointing along unit `dir`.
arrowhead <- function(tip, dir, size, col) {
  dir <- dir / sqrt(sum(dir^2))
  perp <- c(-dir[2], dir[1])
  wings <- tip - dir * size
  notch <- tip - dir * size * 0.58
  w <- size * 0.42
  wing1 <- wings + perp * w
  wing2 <- wings - perp * w
  polygon(c(tip[1], wing1[1], notch[1], wing2[1]),
          c(tip[2], wing1[2], notch[2], wing2[2]),
          col = col, border = NA)
}

theta_axis <- c(0.30, 0.64, 0.71)
theta_axis <- theta_axis / sqrt(sum(theta_axis^2))

canvas_px <- 1600
center_x <- 0.5
center_y <- 0.5
radius <- 0.40

# Orthographic projection of a 3D point (view space) to figure coordinates
proj <- function(p) cbind(center_x + p[, 1] * radius,
                          center_y + p[, 2] * radius)

sphere_png <- file.path(tempdir(), "logo_sphere.png")
png(filename = sphere_png, width = canvas_px, height = canvas_px,
    bg = "transparent")
op <- par(mar = c(0, 0, 0, 0))
plot.new()
plot.window(xlim = c(0, 1), ylim = c(0, 1), asp = 1)

# (a) the ray-cast density globe
npix <- min(1100, round(2 * radius * canvas_px))
sphere_cols <- sphere_raster(theta_axis = theta_axis, npix = npix)
rasterImage(as.raster(sphere_cols), center_x - radius, center_y - radius,
            center_x + radius, center_y + radius, interpolate = TRUE)

# (b) the symmetry axis theta as an arrow from the core out through the pole
axis_pts <- proj(rbind(-0.5 * theta_axis, 1.28 * theta_axis))
lines(axis_pts[, 1], axis_pts[, 2], col = col_axis, lwd = 7, lend = 1)
tip <- proj(rbind(1.28 * theta_axis))[1, ]
dir2 <- c(theta_axis[1], theta_axis[2]); dir2 <- dir2 / sqrt(sum(dir2^2))
arrowhead(tip, dir2, size = 0.055, col = col_axis)

# theta label in white, upright, close to the arrow
perp2 <- c(-dir2[2], dir2[1])
lab <- tip - dir2 * 0.03 + perp2 * 0.085
text(lab[1], lab[2], expression(theta), col = "#FFFFFF", cex = 6.0, font = 3)

# (c) a rotation arc encircling the axis, set low so it clears the theta label;
# the arrowhead ends at the leading (upper) end of the sweep,
# tangent to the ring
b1 <- cross3(theta_axis, c(0, 0, 1)); b1 <- b1 / sqrt(sum(b1^2))
b2 <- cross3(theta_axis, b1); b2 <- b2 / sqrt(sum(b2^2))
h <- 0.55; r_arc <- 0.38
avals <- seq(0.55 * pi, 2.35 * pi, length.out = 240)
ring <- t(sapply(avals, function(a)
  h * theta_axis + r_arc * (cos(a) * b1 + sin(a) * b2)))
ring2 <- proj(ring)
lines(ring2[, 1], ring2[, 2], col = col_axis, lwd = 5.5, lend = 1)
a1 <- avals[length(avals)]
tan3 <- -sin(a1) * b1 + cos(a1) * b2
arrowhead(ring2[nrow(ring2), ], c(tan3[1], tan3[2]), size = 0.048,
          col = col_axis)

par(op)
dev.off()

# Assemble the hex sticker

dir.create("logo", showWarnings = FALSE)
dir.create("man/figures", recursive = TRUE, showWarnings = FALSE)

sticker(
  subplot = sphere_png, s_x = 1, s_y = 1.08, s_width = 0.9, s_height = 0.9,
  package = "rotasym", p_x = 1, p_y = 0.46, p_size = name_size,
  p_color = col_title, p_family = font,
  h_fill = col_fill, h_color = col_border, h_size = hex_border,
  spotlight = FALSE,
  url = "github.com/egarpor/rotasym",
  u_x = url_x, u_y = url_y, u_angle = url_angle, u_size = url_size,
  u_color = col_url,
  dpi = dpi, filename = "logo/logo.png"
)
file.copy("logo/logo.png", "man/figures/logo.png", overwrite = TRUE)

# Tidy up the intermediate sphere image
if (file.exists(sphere_png)) file.remove(sphere_png)
