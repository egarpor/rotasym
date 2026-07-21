
# Generates the rotasym hexagonal sticker logo.
#
# Concept (ported from the Python badge design): an S^2 globe painted with a
# rotationally symmetric density that depends only on theta'x, giving concentric
# magma rings around a tilted symmetry axis theta. A theta arrow along the axis
# and a small rotation arc around it make the rotational invariance explicit.
# Framed in a plum hexagon with an orange border.
#
# Rendering note: instead of plot3D::persp3D (visible facets), the globe is drawn
# with a base-graphics orthographic ray-caster (adapted from the sibling polykde
# logo): for every pixel of the front hemisphere we recover the surface normal,
# evaluate the density there, map it to magma, and apply Lambert shading. This
# gives a smooth, matplotlib-quality sphere with no dependency on OpenGL.
#
# Run from the package root:
#   Rscript data-raw/hexlogo.R
# Output: man/figures/logo.png

library(hexSticker)
library(viridisLite)

# Plum hex with an orange border (matching the Python badge palette)
col_fill   <- "#2A1339"  # deep plum background
col_border <- "#F0812F"  # orange border
col_title  <- "#FCFDBF"  # magma pale yellow wordmark
col_url    <- "#C9A9CE"  # muted plum
col_axis   <- "#FDF4E3"  # warm white for the axis arrow / rotation arc


## 1. Orthographic ray-caster for the density sphere ---------------------------

# Renders the globe as an npix x npix matrix of "#RRGGBBAA" colours. The front
# hemisphere is coloured by g(theta'x) (a vMF angular function, rotationally
# symmetric about theta) and Lambert-shaded; pixels outside the disk are
# transparent with an anti-aliased rim.
sphere_raster <- function(theta_axis, band0 = 58 * pi / 180, bandsd = 0.20,
                          npix = 1000, light = c(-0.42, 0.55, 0.72),
                          gamma = 0.9, ambient = 0.42, diffuse = 0.68,
                          pal = magma(256, begin = 0.04)) {

  theta_axis <- theta_axis / sqrt(sum(theta_axis^2))
  light <- light / sqrt(sum(light^2))

  # Pixel grid over [-1, 1]^2; rows go top (+y) to bottom (-y)
  u <- seq(-1, 1, length.out = npix)
  v <- seq(1, -1, length.out = npix)
  U <- matrix(u, npix, npix, byrow = TRUE)
  V <- matrix(v, npix, npix, byrow = FALSE)
  rr <- sqrt(U^2 + V^2)
  inside <- rr <= 1

  # Front-hemisphere surface normals = unit points on S^2 (view space)
  Z <- sqrt(pmax(0, 1 - U^2 - V^2))
  nx <- U[inside]; ny <- V[inside]; nz <- Z[inside]

  # Rotationally symmetric density concentrated on two parallels symmetric about
  # the axis: as a function of beta = angle to theta only, two Gaussian bands at
  # beta0 and pi - beta0 (echoing the sunspot latitudes). Being a function of
  # theta'x alone, the bands are rings around the axis -> clearly rotationally
  # symmetric.
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
  R <- pmin(255, round(base_rgb[1, ] * shade))
  G <- pmin(255, round(base_rgb[2, ] * shade))
  B <- pmin(255, round(base_rgb[3, ] * shade))

  # Anti-aliased rim: fade alpha over the outer ~2.5 px
  edge <- 2.5 / npix
  A <- round(255 * pmin(1, pmax(0, (1 - rr[inside]) / edge)))

  cols <- character(npix * npix)
  cols[] <- "#00000000"
  cols[which(inside)] <- rgb(R, G, B, A, maxColorValue = 255)
  matrix(cols, npix, npix)

}


## 2. Compose the globe with the axis arrow and rotation arc -------------------

cross3 <- function(a, b) {
  c(a[2] * b[3] - a[3] * b[2],
    a[3] * b[1] - a[1] * b[3],
    a[1] * b[2] - a[2] * b[1])
}

# Filled barbed arrowhead at 2D point `tip`, pointing along 2D unit `dir`. A
# swept-back dart: sharp tip, two wings set back and to the sides, and a concave
# rear notch (forward of the wings) where the shaft enters.
arrowhead <- function(tip, dir, size, col) {
  dir <- dir / sqrt(sum(dir^2))
  perp <- c(-dir[2], dir[1])
  wings <- tip - dir * size                 # wing line, `size` behind the tip
  notch <- tip - dir * size * 0.58          # concave rear, forward of the wings
  w <- size * 0.42                          # half-width at the wings
  wing1 <- wings + perp * w
  wing2 <- wings - perp * w
  polygon(c(tip[1], wing1[1], notch[1], wing2[1]),
          c(tip[2], wing1[2], notch[2], wing2[2]),
          col = col, border = NA)
}

theta_axis <- c(0.30, 0.64, 0.71)
theta_axis <- theta_axis / sqrt(sum(theta_axis^2))

W <- 1600
cx <- 0.5
cy <- 0.5
R  <- 0.40

# Orthographic projection of a 3D point (view space) to figure coordinates
proj <- function(p) cbind(cx + p[, 1] * R, cy + p[, 2] * R)

sphere_png <- file.path("data-raw", "logo_sphere.png")
png(filename = sphere_png, width = W, height = W, bg = "transparent")
op <- par(mar = c(0, 0, 0, 0))
plot.new()
plot.window(xlim = c(0, 1), ylim = c(0, 1), asp = 1)

# (a) the ray-cast density globe
npix <- min(1100, round(2 * R * W))
ras <- sphere_raster(theta_axis = theta_axis, npix = npix)
rasterImage(as.raster(ras), cx - R, cy - R, cx + R, cy + R, interpolate = TRUE)

# (b) the symmetry axis theta as an arrow from the core out through the pole
axis_pts <- proj(rbind(-0.5 * theta_axis, 1.28 * theta_axis))
lines(axis_pts[, 1], axis_pts[, 2], col = col_axis, lwd = 7, lend = 1)
tip <- proj(rbind(1.28 * theta_axis))[1, ]
dir2 <- c(theta_axis[1], theta_axis[2]); dir2 <- dir2 / sqrt(sum(dir2^2))
arrowhead(tip, dir2, size = 0.055, col = col_axis)

# theta label in white, just outside the arrow tip
perp2 <- c(-dir2[2], dir2[1])
lab <- tip + dir2 * 0.05 + perp2 * 0.065
text(lab[1], lab[2], expression(theta), col = "#FFFFFF", cex = 6.5, font = 3)

# (c) a rotation arc encircling the axis just above the visible pole; the
# arrowhead ends at the leading (upper) end of the sweep, tangent to the ring
b1 <- cross3(theta_axis, c(0, 0, 1)); b1 <- b1 / sqrt(sum(b1^2))
b2 <- cross3(theta_axis, b1); b2 <- b2 / sqrt(sum(b2^2))
h <- 1.06; r_arc <- 0.27
avals <- seq(0.55 * pi, 2.35 * pi, length.out = 240)
ring <- t(sapply(avals, function(a)
  h * theta_axis + r_arc * (cos(a) * b1 + sin(a) * b2)))
ring2 <- proj(ring)
lines(ring2[, 1], ring2[, 2], col = col_axis, lwd = 5.5, lend = 1)
a1 <- avals[length(avals)]
tan3 <- -sin(a1) * b1 + cos(a1) * b2          # ring tangent at the arc end
arrowhead(ring2[nrow(ring2), ], c(tan3[1], tan3[2]), size = 0.048,
          col = col_axis)

par(op)
dev.off()


## 3. Assemble the hex sticker -------------------------------------------------

sticker(
  subplot = sphere_png,
  s_x = 1, s_y = 1.08, s_width = 0.9, s_height = 0.9,
  package = "rotasym", p_x = 1, p_y = 0.46, p_size = 16,
  p_color = col_title, p_family = "sans", p_fontface = "bold",
  h_fill = col_fill, h_color = col_border, h_size = 1.5, spotlight = FALSE,
  url = "github.com/egarpor/rotasym", u_size = 3.6, u_y = 0.08,
  u_color = col_url,
  dpi = 320,
  filename = file.path("man", "figures", "logo.png")
)

# Tidy up the intermediate sphere image
if (file.exists(sphere_png)) file.remove(sphere_png)
