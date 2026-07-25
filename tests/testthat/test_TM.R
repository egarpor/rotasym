
# Tangent-vMF setup (p = 3, signs live in S^{p - 2}, so mu has length p - 1)
p <- 3
theta <- c(rep(0, p - 1), 1)
mu <- c(rep(0, p - 2), 1)
kappa_U <- 1
kappa_V <- 2
r_V <- function(n) r_g_vMF(n = n, p = p, kappa = kappa_V)
g_scaled <- function(t, log) {
  g_vMF(t, p = p, kappa = kappa_V, scaled = TRUE, log = log)
}

test_that("TM density integrates to one and agrees with its sampler", {

  for (p in p_dims_tang) {

    theta <- c(rep(0, p - 1), 1)
    mu <- c(rep(0, p - 2), 1)
    r_V <- function(n) r_g_vMF(n = n, p = p, kappa = kappa_V)
    g_scaled <- function(t, log) {
      g_vMF(t, p = p, kappa = kappa_V, scaled = TRUE, log = log)
    }
    expect_distribution(
      d = function(x, log = FALSE) {
        d_TM(x = x, theta = theta, g_scaled = g_scaled, mu = mu,
             kappa = kappa_U, log = log)
      },
      r = function(n) {
        r_TM(n = n, theta = theta, r_V = r_V, mu = mu, kappa = kappa_U)
      },
      p = p, seed = 82 + 3L * p)

  }

})

test_that("TM edge cases", {

  X <- r_TM(n = 10, theta = theta, r_V = r_V, mu = mu, kappa = kappa_U)
  expect_error(r_TM(n = 40, theta = theta, r_V = r_V, mu = c(0, 0, 1),
                    kappa = kappa_U))
  expect_error(d_TM(x = X, theta = theta, g_scaled = g_scaled, mu = c(0, 0, 1),
                    kappa = kappa_U))

})
