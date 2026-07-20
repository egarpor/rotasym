
test_that("Edge cases r_vMF()", {

  expect_error(r_vMF(n = 1, mu = c(0, 1), kappa = -1))
  expect_error(r_vMF(n = 1, mu = c(0, 1), kappa = 2e15))
  expect_no_error(r_vMF(n = 1, mu = c(0, 1), kappa = 1e15))
  expect_no_error(r_vMF(n = 1, mu = c(0, 1), kappa = 0))

})

test_that("d_vMF evaluates the density for vectors and matrices", {

  mu <- c(0, 1)
  kappa <- 2
  # Vector input equals the one-row matrix input (up to attributes)
  expect_equal(as.numeric(d_vMF(x = c(0, 1), mu = mu, kappa = kappa)),
               as.numeric(d_vMF(x = rbind(c(0, 1)), mu = mu, kappa = kappa)))

  set.seed(30)
  X <- r_vMF(n = 20, mu = mu, kappa = kappa)
  dd <- d_vMF(x = X, mu = mu, kappa = kappa)
  expect_length(dd, 20)
  expect_true(all(dd > 0))
  expect_equal(d_vMF(x = X, mu = mu, kappa = kappa, log = TRUE), log(dd))

  # Closed-form check
  expect_equal(as.numeric(dd),
               as.numeric(c_vMF(p = 2, kappa = kappa) * exp(kappa * X %*% mu)))

  # Dimension mismatch between x and mu
  expect_error(d_vMF(x = rbind(c(1, 0, 0)), mu = c(0, 1), kappa = 1))

})

test_that("r_vMF handles the degenerate p = 1 case", {

  set.seed(31)
  s <- r_vMF(n = 50, mu = 1, kappa = 2)
  expect_true(all(s %in% c(-1, 1)))

})
