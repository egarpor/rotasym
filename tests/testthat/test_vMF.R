
test_that("Edge cases r_vMF()", {

  expect_error(r_vMF(n = 1, mu = c(0, 1), kappa = -1))
  expect_error(r_vMF(n = 1, mu = c(0, 1), kappa = 2e15))
  expect_no_error(r_vMF(n = 1, mu = c(0, 1), kappa = 1e15))
  expect_no_error(r_vMF(n = 1, mu = c(0, 1), kappa = 0))

})
