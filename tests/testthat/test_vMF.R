
# von Mises-Fisher setup
kappa <- 2

test_that("vMF density integrates to one and agrees with its sampler", {

  for (p in p_dims) {

    mu <- c(rep(0, p - 1), 1)
    expect_distribution(
      d = function(x, log = FALSE) {
        d_vMF(x = x, mu = mu, kappa = kappa, log = log)
      },
      r = function(n) r_vMF(n = n, mu = mu, kappa = kappa),
      p = p, seed = 30 + 3L * p,
      kernel = function(x) exp(kappa * as.numeric(x %*% mu)),
      const = c_vMF(p = p, kappa = kappa))

  }

})

test_that("vMF projection along the axis follows the cosines distribution", {

  for (p in p_dims[p_dims > 1]) {

    mu <- c(1, rep(0, p - 1))
    expect_cosines_ks(
      d = function(x) d_vMF(x = x, mu = mu, kappa = kappa),
      r = function(n) r_vMF(n = n, mu = mu, kappa = kappa),
      p = p, seed = 205 + p)

  }

})

test_that("vMF edge cases", {

  expect_error(r_vMF(n = 1, mu = c(0, 1), kappa = -1))
  expect_error(r_vMF(n = 1, mu = c(0, 1), kappa = 2e15))
  expect_no_error(r_vMF(n = 1, mu = c(0, 1), kappa = 1e15))
  expect_no_error(r_vMF(n = 1, mu = c(0, 1), kappa = 0))
  expect_true(all(r_vMF(n = 50, mu = 1, kappa = 2) %in% c(-1, 1)))
  expect_error(d_vMF(x = rbind(c(1, 0, 0)), mu = c(0, 1), kappa = 1))

})
