
# Dimensions swept by the distribution tests. p = 1 is the degenerate case
# S^0 = {-1, 1}; the tangent-normal family requires p >= 2, so it skips it.
p_dims <- c(1, 2, 3, 4, 5, 10)
p_dims_tang <- p_dims[p_dims >= 2]

# Shared Monte Carlo harness for the distribution tests. Verifies that
# density integrates to one, the normalizing constant is correct, and the
# match of density and sampler through E_f[1 / f(X)] = 1 if X ~ f.
expect_distribution <- function(d, r, p, seed, kernel = NULL, const = NULL,
                                M = 1e4, tol = 0.1) {

  # Tag the expectations with the dimension, so that a failure within the loop
  # over dimensions is readily identified
  lab <- function(what) paste0("p = ", p, ": ", what)

  # Sample from the distribution
  set.seed(seed + 1L)
  X <- r(M)

  if (p == 1) {

    # S^0 = {-1, 1} carries the counting measure, so the integral of the
    # density is the two-point sum d(-1) + d(1) and is computed exactly
    x_0 <- cbind(c(-1, 1))

    # (1) Density integrates to one
    expect_equal(sum(d(x_0)), 1, info = lab("integral of the density"))

    # (2) Normalizing constant (w_p(p = 1) = 2 cancels the mean of two atoms)
    if (!is.null(kernel) && !is.null(const)) {

      expect_equal(const * sum(kernel(x_0)), 1,
                   info = lab("normalizing constant"))

    }

    # (3) Sampler frequencies match the density
    expect_lt(max(abs(colMeans(outer(drop(X), c(-1, 1), "==")) - d(x_0))), tol,
              label = lab("density vs. sampler"))

  } else {

    # (1) Density integrates to one
    set.seed(seed)
    U <- r_unif_sphere(n = M, p = p)
    expect_lt(abs(mean(d(U) / d_unif_sphere(U)) - 1), tol,
              label = lab("integral of the density"))

    # (2) Normalizing constant through integration (families with a c_*)
    if (!is.null(kernel) && !is.null(const)) {

      set.seed(seed + 2L)
      Uc <- r_unif_sphere(n = M, p = p)
      expect_lt(abs(const * w_p(p = p) * mean(kernel(Uc)) - 1), tol,
                label = lab("normalizing constant"))

    }

    # (3) E_f[1 / f(X)] = 1, X ~ f
    expect_lt(abs(mean(d_unif_sphere(X) / d(X)) - 1), tol,
              label = lab("density vs. sampler"))

  }

  # Other structural coverage
  expect_equal(dim(X), c(M, p), info = lab("dimension of the sample"))
  expect_equal(sqrt(rowSums(X^2)), rep(1, M), tolerance = 1e-10,
               info = lab("unit norm of the sample"))
  expect_true(all(d(X) > 0), info = lab("positive density"))
  expect_equal(d(X, log = TRUE), log(d(X)), info = lab("log-density"))
  expect_equal(as.numeric(d(X[1, ])),
               as.numeric(d(X[1, , drop = FALSE])),
               info = lab("vector vs. matrix input"))

}
