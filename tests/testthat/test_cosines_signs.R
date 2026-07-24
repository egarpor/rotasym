
test_that("Gamma_theta is semi-orthogonal (analytic and eigen branches)", {

  thetas <- list(c(1, 0, 0),
                 c(0, 1, 0),
                 c(0, 0, 1),
                 c(1, 1, 1) / sqrt(3),
                 c(-1, 0, 0),                  # theta[1] == -1 branch
                 c(-1, 1, 0, 0) / sqrt(2),
                 c(2, -1, 0.5, 1) / sqrt(6.25))
  for (theta in thetas) {

    p <- length(theta)
    for (eig in c(FALSE, TRUE)) {

      G <- Gamma_theta(theta = theta, eig = eig)
      expect_equal(dim(G), c(p, p - 1L))
      # Gamma' Gamma = I_{p - 1}
      expect_equal(crossprod(G), diag(1, p - 1), tolerance = 1e-10)
      # Gamma Gamma' = I_p - theta theta'
      expect_equal(tcrossprod(G), diag(1, p) - tcrossprod(theta),
                   tolerance = 1e-10)

    }

  }

})

test_that("signs have unit norm and correct dimensions", {

  set.seed(5)
  p <- 4
  n <- 50
  theta <- c(0, 0, 1, 0)
  X <- r_unif_sphere(n = n, p = p)
  U <- signs(X = X, theta = theta)

  expect_equal(dim(U), c(n, p - 1L))
  expect_equal(sqrt(rowSums(U^2)), rep(1, n), tolerance = 1e-10)

})

test_that("cosines equal the inner product X %*% theta", {

  set.seed(6)
  p <- 5
  n <- 40
  theta <- c(0, 1, 0, 0, 0)
  X <- r_unif_sphere(n = n, p = p)
  V <- cosines(X = X, theta = theta)

  expect_length(V, n)
  expect_equal(V, drop(X %*% theta), tolerance = 1e-12)
  expect_true(all(abs(V) <= 1 + 1e-10))

})

test_that("signs reuse a supplied Gamma consistently", {

  set.seed(8)
  p <- 3
  n <- 20
  theta <- c(1, 1, 0) / sqrt(2)
  X <- r_unif_sphere(n = n, p = p)
  G <- Gamma_theta(theta = theta)

  expect_equal(signs(X = X, theta = theta, Gamma = G),
               signs(X = X, theta = theta))

})

test_that("signs and cosines can check (and normalize) non-unit X", {

  theta <- c(0, 1)
  X_non_unit <- rbind(c(2, 0), c(0, 3))

  expect_warning(signs(X = X_non_unit, theta = theta, check_X = TRUE),
                 "unit-norm")
  expect_warning(cosines(X = X_non_unit, theta = theta, check_X = TRUE),
                 "unit-norm")

  # After internal normalization the results match those of pre-normalized X
  X_unit <- X_non_unit / sqrt(rowSums(X_non_unit^2))
  expect_equal(
    suppressWarnings(signs(X = X_non_unit, theta = theta, check_X = TRUE)),
    signs(X = X_unit, theta = theta))
  expect_equal(
    suppressWarnings(cosines(X = X_non_unit, theta = theta, check_X = TRUE)),
    cosines(X = X_unit, theta = theta))

})
