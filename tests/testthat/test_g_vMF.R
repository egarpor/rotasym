
test_that("g_vMF scaled/unscaled differ by the vMF normalizing constant", {

  p <- 5
  kappa <- 2
  t <- c(-1, -0.4, 0, 0.3, 1)
  sc <- g_vMF(t = t, p = p, kappa = kappa, scaled = TRUE, log = TRUE)
  un <- g_vMF(t = t, p = p, kappa = kappa, scaled = FALSE, log = TRUE)

  expect_equal(sc - un,
               rep(c_vMF(p = p, kappa = kappa, log = TRUE), length(t)))
  expect_equal(g_vMF(t = t, p = p, kappa = kappa, scaled = TRUE, log = FALSE),
               exp(sc))
  expect_equal(un, kappa * t)

})

test_that("g_vMF is -Inf (0) outside [-1, 1]", {

  t <- c(-1.5, -1, 0, 1, 1.5)
  g_log <- g_vMF(t = t, p = 4, kappa = 1, scaled = FALSE, log = TRUE)
  expect_equal(g_log[c(1, 5)], c(-Inf, -Inf))
  g <- g_vMF(t = t, p = 4, kappa = 1, scaled = FALSE, log = FALSE)
  expect_equal(g[c(1, 5)], c(0, 0))

})

test_that("g_vMF errors on negative kappa", {

  expect_error(g_vMF(t = 0, p = 3, kappa = -1))

})

test_that("c_vMF is vectorized over kappa and handles kappa = 0", {

  p <- 4
  kappas <- c(0, 0.5, 1, 3)
  vec <- c_vMF(p = p, kappa = kappas, log = TRUE)
  sca <- vapply(kappas,
                function(k) c_vMF(p = p, kappa = k, log = TRUE), numeric(1))

  expect_equal(vec, sca)
  expect_equal(c_vMF(p = p, kappa = 0, log = TRUE), -w_p(p = p, log = TRUE))
  expect_error(c_vMF(p = p, kappa = -1))

})

test_that("Edge cases r_g_vMF", {

  expect_error(r_g_vMF(n = 0, p = 3, kappa = 1))
  expect_error(r_g_vMF(n = 1, p = 0, kappa = 1))
  expect_error(r_g_vMF(n = 1, p = 3, kappa = -1))
  expect_error(r_g_vMF(n = 1, p = 2, kappa = 2e15))

})