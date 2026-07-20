
test_that("test_rotasym returns an htest with correct degrees of freedom", {

  set.seed(42)
  n <- 100
  p <- 6
  theta <- c(1, rep(0, p - 1))
  X <- r_vMF(n = n, mu = theta, kappa = 1)
  df_sc <- 0.5 * (p - 2) * (p + 1)

  expect_s3_class(test_rotasym(X, theta = theta, type = "sc"), "htest")
  expect_equal(unname(test_rotasym(X, theta = theta, type = "sc")$parameter),
               df_sc)
  expect_equal(unname(test_rotasym(X, theta = theta, type = "loc")$parameter),
               p - 1)
  expect_equal(
    unname(test_rotasym(X, theta = theta, type = "loc_vMF")$parameter),
    p - 1)
  expect_equal(unname(test_rotasym(X, theta = theta, type = "hyb")$parameter),
               df_sc + (p - 1))
  expect_equal(
    unname(test_rotasym(X, theta = theta, type = "hyb_vMF")$parameter),
    df_sc + (p - 1))

})

test_that("test_rotasym statistics and p-values are valid", {

  set.seed(1)
  n <- 150
  p <- 5
  theta <- c(0, 1, rep(0, p - 2))
  X <- r_vMF(n = n, mu = theta, kappa = 2)
  for (ty in c("sc", "loc", "loc_vMF", "hyb", "hyb_vMF")) {

    tt <- test_rotasym(X, theta = theta, type = ty)
    expect_gte(unname(tt$statistic), 0)
    expect_gte(unname(tt$p.value), 0)
    expect_lte(unname(tt$p.value), 1)

  }

})

test_that("scatter statistic equals the reference trace form (E1)", {

  set.seed(7)
  n <- 120
  p <- 7
  theta <- c(1, rep(0, p - 1))
  X <- r_vMF(n = n, mu = theta, kappa = 1)
  U <- signs(X = X, theta = theta)
  S <- crossprod(U) / n

  # sum(S^2) is what test_rotasym now uses; tr(S S') is the original expression
  expect_equal(sum(S * S), sum(diag(tcrossprod(S))))
  ref <- 0.5 * n * (p^2 - 1) * (sum(diag(tcrossprod(S))) - 1 / (p - 1))
  expect_equal(unname(test_rotasym(X, theta = theta, type = "sc")$statistic),
               ref)

})

test_that("vMF-location statistic equals the reference diagonal form (E2)", {

  set.seed(9)
  n <- 130
  p <- 6
  theta <- c(1, rep(0, p - 1))
  X <- r_vMF(n = n, mu = theta, kappa = 1.5)
  U <- signs(X = X, theta = theta)
  V <- cosines(X = X, theta = theta)

  # Reference computation using the explicit (p - 1) x (p - 1) diagonal matrix
  V2 <- 1 - V * V
  V_sqrt <- sqrt(V2)
  V_inv_sqrt <- 1 / sqrt(V2)
  V_inv_sqrt[!is.finite(V_inv_sqrt)] <- NA
  D_pg <- (p - 2) * mean(V * V_inv_sqrt, na.rm = TRUE) / ((p - 1) * mean(V))
  Delta <- colSums((1 - D_pg * V_sqrt) * U) / sqrt(n)
  inv_Gamma <- diag((p - 1) / (1 - 2 * D_pg * mean(V_sqrt) +
                                 D_pg * D_pg * mean(V2)),
                    nrow = p - 1, ncol = p - 1)
  ref <- drop(t(Delta) %*% inv_Gamma %*% Delta)

  expect_equal(
    unname(test_rotasym(X, theta = theta, type = "loc_vMF")$statistic), ref)

})

test_that("hybrid statistic is the sum of scatter and location (non-Fisher)", {

  set.seed(11)
  n <- 100
  p <- 5
  theta <- c(1, rep(0, p - 1))
  X <- r_vMF(n = n, mu = theta, kappa = 1)
  sc <- test_rotasym(X, theta = theta, type = "sc")
  loc <- test_rotasym(X, theta = theta, type = "loc")
  hyb <- test_rotasym(X, theta = theta, type = "hyb")

  expect_equal(unname(hyb$statistic),
               unname(sc$statistic) + unname(loc$statistic))
  expect_equal(unname(hyb$parameter),
               unname(sc$parameter) + unname(loc$parameter))

})

test_that("test_rotasym warns for loc/hyb with estimated theta but not vMF", {

  set.seed(13)
  n <- 80
  p <- 4
  theta <- c(1, rep(0, p - 1))
  X <- r_vMF(n = n, mu = theta, kappa = 1)

  expect_warning(test_rotasym(X, theta = spherical_mean, type = "loc"))
  expect_warning(test_rotasym(X, theta = spherical_mean, type = "hyb"))
  expect_no_warning(test_rotasym(X, theta = spherical_mean, type = "loc_vMF"))
  expect_no_warning(test_rotasym(X, theta = spherical_mean, type = "hyb_vMF"))

})

test_that("hybrid tests with Fisher's method have 4 degrees of freedom", {

  set.seed(40)
  n <- 100
  p <- 5
  theta <- c(1, rep(0, p - 1))
  X <- r_vMF(n = n, mu = theta, kappa = 1)

  for (ty in c("hyb", "hyb_vMF")) {

    tt <- test_rotasym(X, theta = theta, type = ty, Fisher = TRUE)
    expect_equal(unname(tt$parameter), 4)
    expect_gte(unname(tt$p.value), 0)
    expect_lte(unname(tt$p.value), 1)

  }

})

test_that("test_rotasym errors on an unknown type", {

  set.seed(15)
  X <- r_vMF(n = 30, mu = c(1, 0, 0), kappa = 1)
  expect_error(test_rotasym(X, theta = c(1, 0, 0), type = "not_a_type"))

})
