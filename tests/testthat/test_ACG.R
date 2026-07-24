
# Angular central Gaussian setup (p = 2)
p <- 2
Lambda <- rbind(c(2, 0.5),
                c(0.5, 1))

test_that("ACG density integrates to one and agrees with its sampler", {

  expect_distribution(
    d = function(x, log = FALSE) d_ACG(x = x, Lambda = Lambda, log = log),
    r = function(n) r_ACG(n = n, Lambda = Lambda),
    p = p, seed = 34,
    kernel = function(x) rowSums((x %*% solve(Lambda)) * x)^(-0.5 * p),
    const = c_ACG(p = p, Lambda = Lambda))

})

test_that("ACG edge cases: Lambda validity, dimension checks, degenerate p = 1", {

  # Non-symmetric and symmetric-but-not-positive-definite Lambda
  expect_error(c_ACG(p = 2, Lambda = rbind(c(1, 2), c(0, 1))))
  expect_error(c_ACG(p = 2, Lambda = rbind(c(1, 2), c(2, 1))))
  expect_error(r_ACG(n = 5, Lambda = rbind(c(1, 2), c(2, 1))))

  # Dimension mismatch between x and Lambda
  expect_error(d_ACG(x = rbind(c(1, 0)), Lambda = diag(3)))

  # p = 1 reduces to the uniform density on {-1, 1}
  x <- cbind(c(-1, 1))
  expect_equal(d_ACG(x = x, Lambda = matrix(1)), d_unif_sphere(x = x))

})
