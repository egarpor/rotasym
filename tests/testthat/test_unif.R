
test_that("w_p matches the surface-area formula and validates p", {

  p <- 1:5
  expect_equal(w_p(p = p), 2 * pi^(p / 2) / gamma(p / 2))
  expect_equal(w_p(p = 3, log = FALSE), 4 * pi)
  expect_equal(w_p(p = 2, log = FALSE), 2 * pi)
  expect_error(w_p(p = 0))

})

test_that("d_unif_sphere is the constant inverse surface area", {

  expect_equal(d_unif_sphere(c(1, 0, 0)), 1 / w_p(p = 3))
  X <- r_unif_sphere(n = 10, p = 3)
  du <- d_unif_sphere(X)
  expect_length(du, 10)
  expect_true(all(abs(du - 1 / w_p(p = 3)) < 1e-10))
  expect_equal(d_unif_sphere(X, log = TRUE), rep(-w_p(p = 3, log = TRUE), 10))
  X2 <- rbind(c(1, 0, 0), c(NA, NA, NA))
  dn <- suppressWarnings(d_unif_sphere(X2))
  expect_true(is.na(dn[2]))
  expect_false(is.na(dn[1]))

})

test_that("r_unif_sphere handles p = 1 and p > 1", {

  s1 <- r_unif_sphere(n = 40, p = 1)
  expect_equal(dim(s1), c(40L, 1L))
  expect_true(all(s1 %in% c(-1, 1)))
  s3 <- r_unif_sphere(n = 30, p = 3)
  expect_equal(dim(s3), c(30L, 3L))
  expect_equal(sqrt(rowSums(s3^2)), rep(1, 30), tolerance = 1e-10)

})
