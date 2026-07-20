
test_that("spherical_mean returns a unit vector aligned with the axis", {

  p <- 5
  theta <- c(1, rep(0, p - 1))
  set.seed(50)
  X <- r_vMF(n = 300, mu = theta, kappa = 10)
  est <- spherical_mean(X)

  expect_length(est, p)
  expect_equal(sqrt(sum(est^2)), 1, tolerance = 1e-10)
  expect_gt(abs(sum(est * theta)), 0.95)

})

test_that("spherical_mean warns when the directional mean is zero", {

  p <- 4
  theta <- c(1, rep(0, p - 1))
  set.seed(51)
  A <- r_vMF(n = 100, mu = theta, kappa = 5)
  # Exactly antipodal data has a directional mean of exactly zero
  X <- rbind(A, -A)
  expect_warning(spherical_mean(X), "zero")

})

test_that("spherical_loc_PCA recovers the axis for a unimodal sample", {

  # Concentrated sample: the axis is the largest-eigenvalue eigenvector (ind 1)
  p <- 4
  theta <- c(1, rep(0, p - 1))
  set.seed(52)
  X <- r_vMF(n = 500, mu = theta, kappa = 5)
  est <- spherical_loc_PCA(X)

  expect_length(est, p)
  expect_equal(sqrt(sum(est^2)), 1, tolerance = 1e-10)
  expect_gt(abs(sum(est * theta)), 0.95)

})

test_that("spherical_loc_PCA recovers the axis for a girdle sample", {

  # Equatorial (girdle) sample orthogonal to theta: the axis is the
  # smallest-eigenvalue eigenvector (ind 2)
  p <- 4
  theta <- c(1, rep(0, p - 1))
  set.seed(53)
  U <- r_unif_sphere(n = 500, p = p - 1)
  X <- U %*% t(Gamma_theta(theta = theta))
  est <- spherical_loc_PCA(X)

  expect_length(est, p)
  expect_equal(abs(sum(est * theta)), 1, tolerance = 1e-6)

})
