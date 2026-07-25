
# Tangent-normal decomposition setup (p = 3, uniform multivariate signs)
p <- 3
theta <- c(rep(0, p - 1), 1)
kappa_V <- 2
g_scaled <- function(t, log) {
  g_vMF(t, p = p, kappa = kappa_V, scaled = TRUE, log = log)
}

# Full cosine density f_V (includes the omega_{p - 1} factor and the Jacobian)
d_V <- function(v, log) {
  log_dens <- w_p(p = p - 1, log = TRUE) + g_scaled(t = v, log = TRUE) +
    0.5 * (p - 3) * log(1 - v^2)
  switch(log + 1, exp(log_dens), log_dens)
}
r_V <- function(n) r_g_vMF(n = n, p = p, kappa = kappa_V)
r_U <- function(n) r_unif_sphere(n = n, p = p - 1)

test_that("tang_norm density integrates to one and agrees with its sampler", {

  for (p in p_dims_tang) {

    theta <- c(rep(0, p - 1), 1)
    g_scaled <- function(t, log) {
      g_vMF(t, p = p, kappa = kappa_V, scaled = TRUE, log = log)
    }
    r_V <- function(n) r_g_vMF(n = n, p = p, kappa = kappa_V)
    r_U <- function(n) r_unif_sphere(n = n, p = p - 1)
    expect_distribution(
      d = function(x, log = FALSE) {
        d_tang_norm(x = x, theta = theta, g_scaled = g_scaled,
                    d_U = d_unif_sphere, log = log)
      },
      r = function(n) r_tang_norm(n = n, theta = theta, r_U = r_U, r_V = r_V),
      p = p, seed = 60 + 3L * p)

  }

})

test_that("tang_norm edge cases", {

  expect_error(r_tang_norm(n = 5, theta = 1,
                           r_U = function(n) matrix(1, n, 1),
                           r_V = function(n) rep(0, n)))
  expect_error(d_tang_norm(x = cbind(c(1, -1)), theta = 1,
                           g_scaled = function(t, log) 0,
                           d_U = d_unif_sphere))
  X <- r_tang_norm(n = 10, theta = theta, r_V = r_V, r_U = r_U)
  expect_error(d_tang_norm(x = X, theta = c(0, 1), g_scaled = g_scaled,
                           d_U = d_unif_sphere))
  expect_error(d_tang_norm(x = X, theta = theta, d_U = d_unif_sphere))
  expect_equal(d_tang_norm(x = X, theta = theta, g_scaled = g_scaled,
                           d_U = d_unif_sphere),
               d_tang_norm(x = X, theta = theta, d_V = d_V,
                           d_U = d_unif_sphere))

})
