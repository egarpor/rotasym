
# von Mises-Fisher setup (p = 3)
p <- 3
mu <- c(rep(0, p - 1), 1)
kappa <- 2

test_that("vMF density integrates to one and agrees with its sampler", {

  expect_distribution(
    d = function(x, log = FALSE) d_vMF(x = x, mu = mu, kappa = kappa, log = log),
    r = function(n) r_vMF(n = n, mu = mu, kappa = kappa),
    p = p, seed = 30,
    kernel = function(x) exp(kappa * as.numeric(x %*% mu)),
    const = c_vMF(p = p, kappa = kappa))

})

test_that("vMF edge cases: kappa guards, degenerate p = 1, dimension checks", {

  # kappa guards and the uniform (kappa = 0) / Wood (large kappa) branches
  expect_error(r_vMF(n = 1, mu = c(0, 1), kappa = -1))
  expect_error(r_vMF(n = 1, mu = c(0, 1), kappa = 2e15))
  expect_no_error(r_vMF(n = 1, mu = c(0, 1), kappa = 1e15))
  expect_no_error(r_vMF(n = 1, mu = c(0, 1), kappa = 0))

  # p = 1 is the degenerate case: draws live in {-1, 1}
  set.seed(33)
  s <- r_vMF(n = 50, mu = 1, kappa = 2)
  expect_true(all(s %in% c(-1, 1)))

  # Dimension mismatch between x and mu
  expect_error(d_vMF(x = rbind(c(1, 0, 0)), mu = c(0, 1), kappa = 1))

})
