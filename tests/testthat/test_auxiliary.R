
test_that("check_unit_norm normalizes non-unit rows with a warning", {

  expect_warning(check_unit_norm(rbind(c(2, 0), c(0, 3))), "unit-norm")

  out <- check_unit_norm(rbind(c(3, 4), c(0, 5)), warnings = FALSE)
  expect_equal(sqrt(rowSums(out^2)), c(1, 1))

})

test_that("check_unit_norm excludes zero rows and errors when none remain", {

  # A zero row is dropped, the non-zero row is kept and normalized
  out <- suppressWarnings(check_unit_norm(rbind(c(0, 0), c(2, 0))))
  expect_equal(nrow(out), 1L)
  expect_equal(as.numeric(out), c(1, 0))

  # A single zero observation (vector) errors
  expect_error(suppressWarnings(check_unit_norm(c(0, 0))))

  # A matrix of only zero rows errors (nothing remains)
  expect_error(suppressWarnings(check_unit_norm(rbind(c(0, 0), c(0, 0)))))

})

test_that("check_unit_norm warns about excluded zero observations", {

  # Two warnings are emitted (normalization and zero exclusion); check both
  w <- capture_warnings(
    check_unit_norm(rbind(c(0, 0), c(2, 0)), warnings = TRUE))
  expect_match(w, "zero", all = FALSE)
  expect_match(w, "unit-norm", all = FALSE)

})

test_that("check_unit_norm propagates NA rows", {

  out <- suppressWarnings(check_unit_norm(rbind(c(1, 0), c(NA, 1), c(2, 0))))
  expect_true(anyNA(out))

})
