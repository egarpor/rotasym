
# Replicated p-values of the five tests over data from a generator gen(n)
p_rep <- function(gen, M, n, theta, seed) {
  types <- c("sc", "loc", "loc_vMF", "hyb", "hyb_vMF")
  set.seed(seed)
  P <- matrix(NA, nrow = M, ncol = length(types),
              dimnames = list(NULL, types))
  for (i in seq_len(M)) {
    X <- gen(n)
    for (ty in types) {
      P[i, ty] <- test_rotasym(X, theta = theta, type = ty)$p.value
    }
  }
  P
}

test_that("Tests work under H0", {

  M <- 200
  n <- 300
  p <- 4
  theta <- c(1, rep(0, p - 1))

  # Rotationally symmetric data (vMF about theta)
  P <- p_rep(gen = function(n) r_vMF(n = n, mu = theta, kappa = 1),
             M = M, n = n, theta = theta, seed = 1)

  # p-values are valid and uniform (KS test does not reject uniformity)
  expect_true(all(P >= 0 & P <= 1))
  for (ty in colnames(P)) {
    expect_gt(ks.test(P[, ty], "punif")$p.value, 0.05)
  }

})

test_that("Tests work under H1", {

  M <- 200
  n <- 300
  p <- 4
  theta <- c(1, rep(0, p - 1))
  r_V <- function(k) r_g_vMF(n = k, p = p, kappa = 1)

  # Tangent-vMF (location) alternative: detected by the location tests
  TM <- p_rep(gen = function(n) {
    r_TM(n = n, theta = theta, r_V = r_V, mu = c(rep(0, p - 2), 1), kappa = 2)
  }, M = M, n = n, theta = theta, seed = 2)

  # Tangent-elliptical (scatter) alternative: detected by the scatter test
  TE <- p_rep(gen = function(n) {
    r_TE(n = n, theta = theta, r_V = r_V, Lambda = diag(c(4, rep(1, p - 2))))
  }, M = M, n = n, theta = theta, seed = 3)

  # Each test detects the alternative(s) it is consistent against
  expect_lt(mean(TE[, "sc"]), 0.3)
  expect_lt(mean(TM[, "loc"]), 0.3)
  expect_lt(mean(TM[, "loc_vMF"]), 0.3)
  expect_lt(max(mean(TM[, "hyb"]), mean(TE[, "hyb"])), 0.3)
  expect_lt(max(mean(TM[, "hyb_vMF"]), mean(TE[, "hyb_vMF"])), 0.3)

})

test_that("Degrees of freedom and hybrid statistic match their references", {

  n <- 120
  p <- 6
  theta <- c(1, rep(0, p - 1))
  X <- r_vMF(n = n, mu = theta, kappa = 1)
  U <- signs(X = X, theta = theta)
  V <- cosines(X = X, theta = theta)

  sc <- test_rotasym(X, theta = theta, type = "sc")
  loc <- test_rotasym(X, theta = theta, type = "loc")
  loc_vMF <- test_rotasym(X, theta = theta, type = "loc_vMF")
  hyb <- test_rotasym(X, theta = theta, type = "hyb")

  # Degrees of freedom
  df_sc <- 0.5 * (p - 2) * (p + 1)
  expect_equal(unname(sc$parameter), df_sc)
  expect_equal(unname(loc$parameter), p - 1)
  expect_equal(unname(loc_vMF$parameter), p - 1)
  expect_equal(unname(hyb$parameter), df_sc + (p - 1))
  expect_equal(unname(test_rotasym(X, theta = theta, type = "hyb",
                                   Fisher = TRUE)$parameter), 4)

  # Hybrid statistic is the sum of the scatter and location statistics
  expect_equal(unname(hyb$statistic),
               unname(sc$statistic) + unname(loc$statistic))

})

test_that("Edge cases", {

  set.seed(13)
  n <- 80
  p <- 4
  theta <- c(1, rep(0, p - 1))
  X <- r_vMF(n = n, mu = theta, kappa = 1)

  # loc/hyb are not calibrated with an estimated theta (warn); vMF variants are
  expect_warning(test_rotasym(X, theta = spherical_mean, type = "loc"))
  expect_warning(test_rotasym(X, theta = spherical_mean, type = "hyb"))
  expect_no_warning(test_rotasym(X, theta = spherical_mean, type = "loc_vMF"))
  expect_no_warning(test_rotasym(X, theta = spherical_mean, type = "hyb_vMF"))

  # Unknown type
  expect_error(test_rotasym(X, theta = theta, type = "not_a_type"))

})
