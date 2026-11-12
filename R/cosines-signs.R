

#' @title Cosines and multivariate signs of a hyperspherical sample about a
#' given location
#'
#' @description Computation of the cosines and multivariate signs of the
#' hyperspherical sample
#' \eqn{\boldsymbol{X}_1,\ldots,\boldsymbol{X}_n\in \mathcal{S}^{p-1}} about a
#' location \eqn{\boldsymbol{\theta}\in \mathcal{S}^{p-1}}, for
#' \eqn{\mathcal{S}^{p-1}:=\{\boldsymbol{x}\in
#' \mathbb{R}^p:\|\boldsymbol{x}\|=1\}} with \eqn{p\ge 2}. The \emph{cosines}
#' are defined as
#' \deqn{V_i:=\boldsymbol{X}_i'\boldsymbol{\theta},\quad i=1,\ldots,n,}
#' whereas the \emph{multivariate signs} are the vectors
#' \eqn{\boldsymbol{U}_1,\ldots,\boldsymbol{U}_n\in \mathcal{S}^{p-2}} defined
#' as
#' \deqn{\boldsymbol{U}_i :=
#' \boldsymbol{\Gamma}_{\boldsymbol{\theta}}\boldsymbol{X}_i/
#' \|\boldsymbol{\Gamma}_{\boldsymbol{\theta}}\boldsymbol{X}_i\|,\quad
#' i=1,\ldots,n.}
#' The projection matrix \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}} is a
#' \eqn{p\times (p-1)} semi-orthogonal matrix that satisfies
#' \deqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}'
#' \boldsymbol{\Gamma}_{\boldsymbol{\theta}}=\boldsymbol{I}_{p-1}
#' \quad\mathrm{and}\quad\boldsymbol{\Gamma}_{\boldsymbol{\theta}}
#' \boldsymbol{\Gamma}_{\boldsymbol{\theta}}'=
#' \boldsymbol{I}_p-\boldsymbol{\theta}\boldsymbol{\theta}'.}
#' where \eqn{\boldsymbol{I}_p} is the identity matrix of dimension \eqn{p}.
#'
#' @param X hyperspherical data, a matrix of size \code{c(n, p)} with unit-norm
#' rows. \code{NA}s are allowed. For \code{prod_Gamma_theta}, any matrix of
#' size \code{c(n, p)}, or \code{c(n, p - 1)} if \code{transpose = TRUE}. A
#' vector is a single observation.
#' @param theta a unit-norm vector of length \code{p}. Normalized internally if
#' it does not have unit norm (with a \code{warning} message).
#' @param Gamma output from \code{Gamma_theta(theta = theta)}. If \code{NULL}
#' (default), the product with \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}}
#' is computed without forming the \eqn{p\times (p-1)} matrix.
#' @param check_X check the unit norms on the rows of \code{X}? Defaults to
#' \code{FALSE} for performance reasons.
#' @param eig find \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}} using an
#' eigendecomposition of
#' \eqn{\boldsymbol{I}_p-\boldsymbol{\theta}\boldsymbol{\theta}'}
#' (inefficient)? Defaults to \code{FALSE}.
#' @param transpose multiply by
#' \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}'} instead of by
#' \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}}? Defaults to
#' \code{FALSE}.
#' @return Depending on the function:
#' \itemize{
#' \item \code{cosines}: a vector of length \code{n} with the cosines of
#' \code{X}.
#' \item \code{signs}: a matrix of size \code{c(n, p - 1)} with the multivariate
#' signs of \code{X}.
#' \item \code{Gamma_theta}: a projection matrix
#' \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}} of size \code{c(p, p - 1)}.
#' \item \code{prod_Gamma_theta}: a matrix of size \code{c(n, p - 1)} with
#' \eqn{\boldsymbol{X}\boldsymbol{\Gamma}_{\boldsymbol{\theta}}}, or of size
#' \code{c(n, p)} with
#' \eqn{\boldsymbol{X}\boldsymbol{\Gamma}_{\boldsymbol{\theta}}'} if
#' \code{transpose = TRUE}.
#' }
#' @details Note that the projection matrix
#' \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}} is \emph{not} unique. In
#' particular, any completion of \eqn{\boldsymbol{\theta}} to an orthonormal
#' basis
#' \eqn{\{\boldsymbol{\theta},\boldsymbol{v}_1,\ldots,\boldsymbol{v}_{p-1}\}}
#' gives a set of \eqn{p-1} orthonormal \eqn{p}-vectors
#' \eqn{\{\boldsymbol{v}_1,\ldots,\boldsymbol{v}_{p-1}\}} that conform the
#' columns of \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}}. If
#' \code{eig = FALSE}, this approach is employed by rotating the canonical
#' completion of \eqn{\boldsymbol{e}_1=(1,0,\ldots,0)},
#' \eqn{\{\boldsymbol{e}_2,\ldots,\boldsymbol{e}_p\}}, by the rotation matrix
#' that rotates \eqn{\boldsymbol{e}_1} to \eqn{\boldsymbol{\theta}}:
#' \deqn{\boldsymbol{H}_{\boldsymbol{\theta}}=
#' (\boldsymbol{\theta}+\boldsymbol{e}_1)
#' (\boldsymbol{\theta}+\boldsymbol{e}_1)'/(1+\theta_1)-\boldsymbol{I}_p.}
#' If \code{eig = TRUE}, then a much more expensive eigendecomposition of
#' \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}
#' \boldsymbol{\Gamma}_{\boldsymbol{\theta}}'=
#' \boldsymbol{I}_p-\boldsymbol{\theta}\boldsymbol{\theta}'} is performed for
#' determining \eqn{\{\boldsymbol{v}_1,\ldots,\boldsymbol{v}_{p-1}\}}.
#'
#' \code{prod_Gamma_theta} computes the products
#' \eqn{\boldsymbol{X}\boldsymbol{\Gamma}_{\boldsymbol{\theta}}} and
#' \eqn{\boldsymbol{X}\boldsymbol{\Gamma}_{\boldsymbol{\theta}}'}, with the
#' \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}} of \code{eig = FALSE},
#' without forming \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}}. This saves
#' the \eqn{O(p^2)} memory of the \eqn{p\times (p-1)} matrix, which is relevant
#' for large dimensions \eqn{p}.
#'
#' If \code{signs} and \code{cosines} are called with \code{X} without unit
#' norms in the rows, then the results will be spurious. Setting
#' \code{check_X = TRUE} prevents this from happening.
#' @references
#' García-Portugués, E., Paindaveine, D., and Verdebout, T. (2020). On optimal
#' tests for rotational symmetry against new classes of hyperspherical
#' distributions. \emph{Journal of the American Statistical Association},
#' 115(532):1873--1887. \doi{10.1080/01621459.2019.1665527}
#' @seealso \code{\link{tang-norm-decomp}}, \code{\link{test_rotasym}}.
#' @examples
#' # Gamma_theta
#' theta <- c(0, 1)
#' Gamma_theta(theta = theta)
#'
#' # prod_Gamma_theta gives the same products without forming Gamma_theta
#' X <- r_unif_sphere(n = 5, p = 2)
#' prod_Gamma_theta(X = X, theta = theta) - X %*% Gamma_theta(theta = theta)
#'
#' # Signs and cosines for p = 2
#' L <- rbind(c(1, 0.5),
#'            c(0.5, 1))
#' X <- r_ACG(n = 1e3, Lambda = L)
#' old_par <- par(mfrow = c(1, 2))
#' plot(signs(X = X, theta = theta), main = "Signs", xlab = expression(x[1]),
#'      ylab = expression(x[2]))
#' hist(cosines(X = X, theta = theta), prob = TRUE, main = "Cosines",
#'      xlab = expression(x * "'" * theta))
#' par(old_par)
#'
#' # Signs and cosines for p = 3
#' L <- rbind(c(2, 0.25, 0.25),
#'            c(0.25, 0.5, 0.25),
#'            c(0.25, 0.25, 0.5))
#' X <- r_ACG(n = 1e3, Lambda = L)
#' old_par <- par(mfrow = c(1, 2))
#' theta <- c(0, 1, 0)
#' plot(signs(X = X, theta = theta), main = "Signs", xlab = expression(x[1]),
#'      ylab = expression(x[2]))
#' hist(cosines(X = X, theta = theta), prob = TRUE, main = "Cosines",
#'      xlab = expression(x * "'" * theta))
#' par(old_par)
#' @name cosines-signs


#' @rdname cosines-signs
#' @export
signs <- function(X, theta, Gamma = NULL, check_X = FALSE) {

  # Check unit norms of X
  if (check_X) {

    X <- check_unit_norm(x = X, warnings = TRUE)

  }

  # Reuse Gamma?
  if (is.null(Gamma)) {

    U <- prod_Gamma_theta(X = X, theta = theta)

  } else {

    U <- X %*% Gamma

  }

  # Compute signs
  return(U / sqrt(rowSums(U * U, na.rm = TRUE)))

}


#' @rdname cosines-signs
#' @export
cosines <- function(X, theta, check_X = FALSE) {

  # Check unit norm of theta
  theta <- check_unit_norm(theta, warnings = TRUE)

  # Check unit norms of X
  if (check_X) {

    X <- check_unit_norm(x = X, warnings = TRUE)

  }

  # Cosines
  return(drop(X %*% theta))

}


#' @rdname cosines-signs
#' @export
Gamma_theta <- function(theta, eig = FALSE) {

  # Check unit norm of theta
  theta <- check_unit_norm(x = theta, warnings = TRUE)

  # Dimension and identity matrix
  p <- length(theta)
  I <- diag(1, nrow = p, ncol = p)

  # Matrix obtained by eigen decomposition or by an analytical orthonormal
  # completion of theta (much faster).
  if (eig) {

    Gamma <- eigen(I - tcrossprod(theta),
                   symmetric = TRUE)$vectors[, -p, drop = FALSE]

  } else {

    Gamma <- prod_Gamma_theta(X = I, theta = theta)

  }

  # Return semi-orthogonal matrix
  return(Gamma)

}


#' @rdname cosines-signs
#' @export
prod_Gamma_theta <- function(X, theta, transpose = FALSE) {

  # Check unit norm of theta
  theta <- check_unit_norm(x = theta, warnings = TRUE)

  # A vector is a single observation
  if (is.null(dim(X))) {

    X <- matrix(X, nrow = 1)

  }

  # Gamma_theta = (w w' / w_1 - I_p)[, -1], w = theta + e_1. For theta_1 < 0,
  # w_1 = 1 + theta_1 = ||theta_{-1}||^2 / (1 - theta_1) avoids the
  # cancellation that breaks orthogonality for theta near -e_1.
  w <- theta
  w[1] <- switch((theta[1] < 0) + 1, 1 + theta[1],
                 sum(theta[-1]^2) / (1 - theta[1]))

  # a = w / w_1, except for theta = -e_1, where w = 0 and
  # Gamma_theta = -I_p[, -1].
  a <- switch((w[1] == 0) + 1, w / w[1], w)

  # X Gamma_theta = (X w) a_{-1}' - X[, -1] and
  # X Gamma_theta' = (X w_{-1}) a' - (0, X).
  if (transpose) {

    XG <- tcrossprod(drop(X %*% w[-1]), a) - cbind(0, X)

  } else {

    XG <- tcrossprod(drop(X %*% w), a[-1]) - X[, -1, drop = FALSE]

  }

  # Same dimnames as X %*% Gamma_theta
  XG <- unname(XG)
  rownames(XG) <- rownames(X)
  return(XG)

}
