
# Shared p = 3 setup for the tangent-normal decomposition
p <- 3
theta <- c(rep(0, p - 1), 1)
kappa_V <- 2
g_scaled <- function(t, log) {
  g_vMF(t, p = p - 1, kappa = kappa_V, scaled = TRUE, log = log)
}
# Full cosine density f_V (includes the omega_{p-1} factor)
d_V <- function(v, log) {
  log_dens <- w_p(p = p - 1, log = TRUE) + g_scaled(t = v, log = TRUE) +
    0.5 * (p - 3) * log(1 - v^2)
  switch(log + 1, exp(log_dens), log_dens)
}
r_V <- function(n) r_g_vMF(n = n, p = p, kappa = kappa_V)
r_U <- function(n) r_unif_sphere(n = n, p = p - 1)

test_that("r_tang_norm returns unit-norm rows and validates p", {

  set.seed(60)
  X <- r_tang_norm(n = 40, theta = theta, r_V = r_V, r_U = r_U)
  expect_equal(dim(X), c(40L, p))
  expect_equal(sqrt(rowSums(X^2)), rep(1, 40), tolerance = 1e-10)

  # p < 2 is not allowed
  expect_error(r_tang_norm(n = 5, theta = 1,
                           r_U = function(n) matrix(1, n, 1),
                           r_V = function(n) rep(0, n)))

})

test_that("d_tang_norm agrees whether given g_scaled or the full d_V", {

  set.seed(61)
  X <- r_tang_norm(n = 50, theta = theta, r_V = r_V, r_U = r_U)
  d1 <- d_tang_norm(x = X, theta = theta, g_scaled = g_scaled,
                    d_U = d_unif_sphere)
  d2 <- d_tang_norm(x = X, theta = theta, d_V = d_V, d_U = d_unif_sphere)

  expect_length(d1, 50)
  expect_true(all(d1 > 0))
  expect_equal(d1, d2)
  expect_equal(d_tang_norm(x = X, theta = theta, g_scaled = g_scaled,
                           d_U = d_unif_sphere, log = TRUE),
               log(d1))

  # Vector input equals the one-row matrix input (up to attributes)
  expect_equal(as.numeric(d_tang_norm(x = X[1, ], theta = theta,
                                      g_scaled = g_scaled,
                                      d_U = d_unif_sphere)),
               as.numeric(d_tang_norm(x = rbind(X[1, ]), theta = theta,
                                      g_scaled = g_scaled,
                                      d_U = d_unif_sphere)))

})

test_that("d_tang_norm validates dimensions and required arguments", {

  set.seed(62)
  X <- r_tang_norm(n = 10, theta = theta, r_V = r_V, r_U = r_U)

  # p < 2
  expect_error(d_tang_norm(x = cbind(c(1, -1)), theta = 1,
                           g_scaled = function(t, log) 0,
                           d_U = d_unif_sphere))
  # Dimension mismatch between x and theta
  expect_error(d_tang_norm(x = X, theta = c(0, 1), g_scaled = g_scaled,
                           d_U = d_unif_sphere))
  # Neither g_scaled nor d_V supplied
  expect_error(d_tang_norm(x = X, theta = theta, d_U = d_unif_sphere))

})
