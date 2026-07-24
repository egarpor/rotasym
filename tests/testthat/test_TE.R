
# Tangent-elliptical setup (p = 3, signs live in S^{p - 2})
p <- 3
theta <- c(rep(0, p - 1), 1)
Lambda <- matrix(0.5, nrow = p - 1, ncol = p - 1)
diag(Lambda) <- 1
kappa_V <- 2
r_V <- function(n) r_g_vMF(n = n, p = p, kappa = kappa_V)
g_scaled <- function(t, log) {
  g_vMF(t, p = p, kappa = kappa_V, scaled = TRUE, log = log)
}

test_that("TE density integrates to one and agrees with its sampler", {

  expect_distribution(
    d = function(x, log = FALSE) {
      d_TE(x = x, theta = theta, g_scaled = g_scaled, Lambda = Lambda, log = log)
    },
    r = function(n) r_TE(n = n, theta = theta, r_V = r_V, Lambda = Lambda),
    p = p, seed = 70)

})

test_that("TE edge cases: theta and Lambda dimension coherence", {

  set.seed(73)
  X <- r_TE(n = 10, theta = theta, r_V = r_V, Lambda = Lambda)

  # Lambda must be (p - 1) x (p - 1)
  expect_error(r_TE(n = 40, theta = theta, r_V = r_V, Lambda = diag(p)))
  expect_error(d_TE(x = X, theta = theta, g_scaled = g_scaled,
                    Lambda = diag(p)))

})
