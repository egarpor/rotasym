
test_that("c_ACG matches the closed-form constant and checks Lambda", {

  Lambda <- rbind(c(2, 0.5),
                  c(0.5, 1))
  expect_equal(c_ACG(p = 2, Lambda = Lambda, log = TRUE),
               -(w_p(p = 2, log = TRUE) + 0.5 * log(det(Lambda))))
  expect_equal(c_ACG(p = 2, Lambda = Lambda),
               exp(c_ACG(p = 2, Lambda = Lambda, log = TRUE)))

  # Non-symmetric Lambda
  expect_error(c_ACG(p = 2, Lambda = rbind(c(1, 2), c(0, 1))))
  # Symmetric but not positive definite (eigenvalues 3, -1)
  expect_error(c_ACG(p = 2, Lambda = rbind(c(1, 2), c(2, 1))))

})

test_that("r_ACG returns unit-norm rows of the right size", {

  Lambda <- rbind(c(2, 0.5),
                  c(0.5, 1))
  set.seed(35)
  X <- r_ACG(n = 25, Lambda = Lambda)
  expect_equal(dim(X), c(25L, 2L))
  expect_equal(sqrt(rowSums(X^2)), rep(1, 25), tolerance = 1e-10)

  # Non-positive-definite Lambda errors in chol()
  expect_error(r_ACG(n = 5, Lambda = rbind(c(1, 2), c(2, 1))))

})

test_that("d_ACG matches the closed-form density for p >= 2", {

  Lambda <- rbind(c(2, 0.5),
                  c(0.5, 1))
  set.seed(34)
  X <- r_ACG(n = 30, Lambda = Lambda)
  dd <- d_ACG(x = X, Lambda = Lambda)
  expect_length(dd, 30)
  expect_true(all(dd > 0))

  cc <- c_ACG(p = 2, Lambda = Lambda, log = TRUE)
  manual <- exp(cc - 0.5 * 2 * log(rowSums((X %*% solve(Lambda)) * X)))
  expect_equal(dd, manual)
  expect_equal(d_ACG(x = X, Lambda = Lambda, log = TRUE), log(dd))

  # Vector input equals the one-row matrix input (up to attributes)
  expect_equal(as.numeric(d_ACG(x = c(1, 0), Lambda = Lambda)),
               as.numeric(d_ACG(x = rbind(c(1, 0)), Lambda = Lambda)))

  # Dimension mismatch between x and Lambda
  expect_error(d_ACG(x = X, Lambda = diag(3)))

})

test_that("d_ACG reduces to the uniform density when p = 1", {

  x <- cbind(c(-1, 1))
  expect_equal(d_ACG(x = x, Lambda = matrix(1)),
               d_unif_sphere(x = x))

})
