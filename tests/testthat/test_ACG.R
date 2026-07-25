
# Angular central Gaussian setup
kappa <- 2

test_that("ACG density integrates to one and agrees with its sampler", {

  for (p in p_dims) {

    Lambda <- diag(c(rep(1 / (p + kappa), p - 1), (1 + kappa) / (p + kappa)),
                   nrow = p, ncol = p)
    expect_distribution(
      d = function(x, log = FALSE) d_ACG(x = x, Lambda = Lambda, log = log),
      r = function(n) r_ACG(n = n, Lambda = Lambda),
      p = p, seed = 36 + 3L * p,
      kernel = function(x) rowSums((x %*% solve(Lambda)) * x)^(-0.5 * p),
      const = c_ACG(p = p, Lambda = Lambda))

  }

})

test_that("ACG projection along the axis follows the cosines distribution", {

  for (p in p_dims[p_dims > 1]) {

    Lambda <- diag(c((1 + kappa) / (p + kappa), rep(1 / (p + kappa), p - 1)),
                   nrow = p, ncol = p)
    expect_cosines_ks(
      d = function(x) d_ACG(x = x, Lambda = Lambda),
      r = function(n) r_ACG(n = n, Lambda = Lambda),
      p = p, seed = 215 + p)

  }

})

test_that("ACG edge cases", {

  expect_error(c_ACG(p = 2, Lambda = rbind(c(1, 2), c(0, 1))))
  expect_error(c_ACG(p = 2, Lambda = rbind(c(1, 2), c(2, 1))))
  expect_error(r_ACG(n = 5, Lambda = rbind(c(1, 2), c(2, 1))))
  expect_error(d_ACG(x = rbind(c(1, 0)), Lambda = diag(3)))
  x <- r_unif_sphere(n = 10, p = 2)
  Lambda <- rbind(c(2, 0.5),
                  c(0.5, 1))
  expect_equal(d_ACG(x = x, Lambda = Lambda),
               d_ACG(x = x, Lambda = 3 * Lambda))
  x <- cbind(c(-1, 1))
  expect_equal(d_ACG(x = x, Lambda = matrix(1)), d_unif_sphere(x = x))

})
