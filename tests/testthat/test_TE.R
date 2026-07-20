
# p = 3 tangent-elliptical setup (signs live in S^{p - 2})
p <- 3
theta <- c(rep(0, p - 1), 1)
Lambda <- matrix(0.5, nrow = p - 1, ncol = p - 1)
diag(Lambda) <- 1
kappa_V <- 2
r_V <- function(n) r_g_vMF(n = n, p = p, kappa = kappa_V)
g_scaled <- function(t, log) {
  g_vMF(t, p = p - 1, kappa = kappa_V, scaled = TRUE, log = log)
}

test_that("r_TE returns unit-norm rows and checks coherence", {

  set.seed(70)
  X <- r_TE(n = 40, theta = theta, r_V = r_V, Lambda = Lambda)
  expect_equal(dim(X), c(40L, p))
  expect_equal(sqrt(rowSums(X^2)), rep(1, 40), tolerance = 1e-10)

  # Lambda must be (p - 1) x (p - 1)
  expect_error(r_TE(n = 40, theta = theta, r_V = r_V, Lambda = diag(p)))

})

test_that("d_TE equals d_tang_norm with an ACG sign density", {

  set.seed(71)
  X <- r_TE(n = 50, theta = theta, r_V = r_V, Lambda = Lambda)
  d_te <- d_TE(x = X, theta = theta, g_scaled = g_scaled, Lambda = Lambda)
  d_manual <- d_tang_norm(x = X, theta = theta, g_scaled = g_scaled,
                          d_U = function(z, log) {
                            d_ACG(x = z, Lambda = Lambda, log = log)
                          })

  expect_length(d_te, 50)
  expect_true(all(d_te > 0))
  expect_equal(d_te, d_manual)
  expect_equal(d_TE(x = X, theta = theta, g_scaled = g_scaled,
                    Lambda = Lambda, log = TRUE), log(d_te))

  # Coherence check
  expect_error(d_TE(x = X, theta = theta, g_scaled = g_scaled,
                    Lambda = diag(p)))

})
