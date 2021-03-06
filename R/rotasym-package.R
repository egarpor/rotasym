

#' @title \pkg{rotasym} -- Tests for Rotational Symmetry on the Hypersphere
#'
#' @description Implementation of the tests for rotational symmetry on the
#' hypersphere proposed in García-Portugués, Paindaveine and Verdebout (2020)
#' <doi:10.1080/01621459.2019.1665527>. The package implements the proposed
#' distributions on the hypersphere based on the tangent-normal decomposition.
#' It also allows for the replication of the data application considered in
#' the paper.
#'
#' @author Eduardo García-Portugués, Davy Paindaveine, and Thomas Verdebout.
#' @references
#' García-Portugués, E., Paindaveine, D., Verdebout, T. (2020) On optimal tests
#' for rotational symmetry against new classes of hyperspherical distributions.
#' \emph{Journal of the American Statistical Association}, 115(532):1873--1887.
#' \doi{10.1080/01621459.2019.1665527}
#' @docType package
#' @name rotasym-package
#' @import stats Rcpp
#' @useDynLib rotasym
#' @aliases rotasym rotasym-package
NULL
