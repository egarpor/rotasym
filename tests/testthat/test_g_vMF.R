
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

test_that("c_vMF is vectorized over p and kappa and handles kappa = 0", {

  p <- 4
  kappas <- c(0, 0.5, 1, 3)
  vec <- c_vMF(p = p, kappa = kappas, log = TRUE)
  sca <- vapply(kappas,
                function(k) c_vMF(p = p, kappa = k, log = TRUE), numeric(1))

  expect_equal(vec, sca)
  expect_equal(c_vMF(p = c(2, 3), kappa = kappas, log = TRUE),
               mapply(function(p, k) c_vMF(p = p, kappa = k, log = TRUE),
                      c(2, 3, 2, 3), kappas))
  expect_equal(c_vMF(p = p, kappa = 0, log = TRUE), -w_p(p = p, log = TRUE))
  expect_error(c_vMF(p = p, kappa = -1))

})

test_that("c_vMF matches closed forms for large kappa and p", {

  # p = 3: c = kappa / (4 * pi * sinh(kappa))
  kappa <- c(1, 1e6, 1e7)
  expect_equal(c_vMF(p = 3, kappa = kappa, log = TRUE),
               log(kappa) - log(2 * pi) - kappa - log1p(-exp(-2 * kappa)))

  # p = 500, kappa = 1: power series of I_nu(1), nu = 249
  nu <- 249
  k <- 0:20
  log_terms <- -(2 * k + nu) * log(2) - lfactorial(k) - lgamma(nu + k + 1)
  log_I <- max(log_terms) + log(sum(exp(log_terms - max(log_terms))))
  expect_equal(c_vMF(p = 500, kappa = 1, log = TRUE),
               -250 * log(2 * pi) - log_I)

})

test_that("Edge cases r_g_vMF", {

  expect_error(r_g_vMF(n = 0, p = 3, kappa = 1))
  expect_error(r_g_vMF(n = 1, p = 0, kappa = 1))
  expect_error(r_g_vMF(n = 1, p = 3, kappa = -1))
  expect_error(r_g_vMF(n = 1, p = 2, kappa = 2e15))

  # kappa = 0 with p = 3 skips the inverse transform: Unif(-1, 1) cosines
  set.seed(987202226)
  expect_gt(ks.test(x = r_g_vMF(n = 500, p = 3, kappa = 0), y = "punif",
                    min = -1, max = 1)$p.value, 0.01)

})
