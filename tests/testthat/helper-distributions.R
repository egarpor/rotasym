
# Shared Monte Carlo harness for the distribution tests. Verifies that
# density integrates to one, the normalizing constant is correct, and the
# match of density and sampler through E_f[1 / f(X)] = 1 if X ~ f.
expect_distribution <- function(d, r, p, seed, kernel = NULL, const = NULL,
                                M = 5e3, tol = 0.1) {

  # (1) Density integrates to one
  set.seed(seed)
  U <- r_unif_sphere(n = M, p = p)
  expect_lt(abs(mean(d(U) / d_unif_sphere(U)) - 1), tol)

  # (2) Normalizing constant through integration (families with a c_* function)
  if (!is.null(kernel) && !is.null(const)) {

    set.seed(seed + 2L)
    Uc <- r_unif_sphere(n = M, p = p)
    expect_lt(abs(const * w_p(p = p) * mean(kernel(Uc)) - 1), tol)

  }

  # (3) E_f[1 / f(X)] = 1, X ~ f
  set.seed(seed + 1L)
  X <- r(M)
  expect_lt(abs(mean(d_unif_sphere(X) / d(X)) - 1), tol)

  # Other structural coverage
  expect_equal(dim(X), c(M, p))
  expect_equal(sqrt(rowSums(X^2)), rep(1, M), tolerance = 1e-10)
  expect_true(all(d(X) > 0))
  expect_equal(d(X, log = TRUE), log(d(X)))
  expect_equal(as.numeric(d(X[1, ])),
               as.numeric(d(X[1, , drop = FALSE])))

}
