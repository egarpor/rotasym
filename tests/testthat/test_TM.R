
# p = 3 tangent-vMF setup (signs live in S^{p - 2}, so mu has length p - 1)
p <- 3
theta <- c(rep(0, p - 1), 1)
mu <- c(rep(0, p - 2), 1)
kappa_U <- 1
kappa_V <- 2
r_V <- function(n) r_g_vMF(n = n, p = p, kappa = kappa_V)
g_scaled <- function(t, log) {
  g_vMF(t, p = p - 1, kappa = kappa_V, scaled = TRUE, log = log)
}

test_that("r_TM returns unit-norm rows and checks coherence", {

  set.seed(80)
  X <- r_TM(n = 40, theta = theta, r_V = r_V, mu = mu, kappa = kappa_U)
  expect_equal(dim(X), c(40L, p))
  expect_equal(sqrt(rowSums(X^2)), rep(1, 40), tolerance = 1e-10)

  # mu must have length p - 1
  expect_error(r_TM(n = 40, theta = theta, r_V = r_V, mu = c(0, 0, 1),
                    kappa = kappa_U))

})

test_that("d_TM equals d_tang_norm with a vMF sign density", {

  set.seed(81)
  X <- r_TM(n = 50, theta = theta, r_V = r_V, mu = mu, kappa = kappa_U)
  d_tm <- d_TM(x = X, theta = theta, g_scaled = g_scaled, mu = mu,
               kappa = kappa_U)
  d_manual <- d_tang_norm(x = X, theta = theta, g_scaled = g_scaled,
                          d_U = function(z, log) {
                            d_vMF(x = z, mu = mu, kappa = kappa_U, log = log)
                          })

  expect_length(d_tm, 50)
  expect_true(all(d_tm > 0))
  expect_equal(d_tm, d_manual)
  expect_equal(d_TM(x = X, theta = theta, g_scaled = g_scaled, mu = mu,
                    kappa = kappa_U, log = TRUE), log(d_tm))

  # Coherence check
  expect_error(d_TM(x = X, theta = theta, g_scaled = g_scaled,
                    mu = c(0, 0, 1), kappa = kappa_U))

})
