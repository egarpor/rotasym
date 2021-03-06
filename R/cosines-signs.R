

#' @title Cosines and multivariate signs of a hyperspherical sample about a
#' given location
#'
#' @description Computation of the cosines and multivariate signs of the
#' hyperspherical sample \eqn{\mathbf{X}_1,\ldots,\mathbf{X}_n\in S^{p-1}}{
#' X_1, \ldots, X_n \in S^{p-1}} about a location
#' \eqn{\boldsymbol{\theta}\in S^{p-1}}{\theta \in S^{p-1}},
#' for \eqn{S^{p-1}:=\{\mathbf{x}\in R^p:||\mathbf{x}||=1\}}{
#' S^{p-1} := \{x\in R^p : ||x|| = 1\}} with \eqn{p\ge 2}.
#' The \emph{cosines} are defined as
#' \deqn{V_i:=\mathbf{X}_i'\boldsymbol{\theta},\quad i=1,\ldots,n,}{
#' V_i := X_i'\theta, i = 1, \ldots, n,}
#' whereas the \emph{multivariate signs} are the vectors
#' \eqn{\mathbf{U}_1,\ldots,\mathbf{U}_n\in S^{p-2}}{
#' U_1, \ldots, U_n \in S^{p-2}} defined as
#' \deqn{\mathbf{U}_i := \boldsymbol{\Gamma}_{\boldsymbol{\theta}}\mathbf{X}_i/
#' ||\boldsymbol{\Gamma}_{\boldsymbol{\theta}}\mathbf{X}_i||,\quad
#' i=1,\ldots,n.}{
#' U_i := \Gamma_\theta X_i /
#' ||\Gamma_\theta X_i||, i = 1, \ldots, n.}
#' The projection matrix
#' \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}}{\Gamma_\theta} is a
#' \eqn{p\times (p-1)}{p x (p-1)} semi-orthogonal matrix that satisfies
#' \deqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}'
#' \boldsymbol{\Gamma}_{\boldsymbol{\theta}}=\mathbf{I}_{p-1}
#' \quad\mathrm{and}\quad\boldsymbol{\Gamma}_{\boldsymbol{\theta}}
#' \boldsymbol{\Gamma}_{\boldsymbol{\theta}}'=
#' \mathbf{I}_p-\boldsymbol{\theta}\boldsymbol{\theta}'.}{
#' \Gamma_\theta'\Gamma_\theta = I_{p-1} and
#' \Gamma_\theta\Gamma_\theta' = I_p - \theta\theta',}
#' where \eqn{\mathbf{I}_p}{I_p} is the identity matrix of dimension \eqn{p}.
#'
#' @param X hyperspherical data, a matrix of size \code{c(n, p)} with
#' unit-norm rows. \code{NA}s are allowed.
#' @param theta a unit-norm vector of length \code{p}. Normalized internally
#' if it does not have unit norm (with a \code{warning} message).
#' @param Gamma output from \code{Gamma_theta(theta = theta)}. If \code{NULL}
#' (default), it is computed internally.
#' @param check_X whether to check the unit norms on the rows of \code{X}.
#' Defaults to \code{FALSE} for performance reasons.
#' @param eig whether \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}}{
#' \Gamma_\theta} is to be found using an eigendecomposition of
#' \eqn{\mathbf{I}_p-\boldsymbol{\theta}\boldsymbol{\theta}'}{
#' I_p - \theta\theta'} (inefficient). Defaults to \code{FALSE}.
#' @return
#' Depending on the function:
#' \itemize{
#' \item \code{cosines}: a vector of length \code{n} with the cosines of
#' \code{X}.
#' \item \code{signs}: a matrix of size \code{c(n, p - 1)} with the
#' multivariate signs of \code{X}.
#' \item \code{Gamma_theta}: a projection matrix
#' \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}}{\Gamma_\theta} of size
#' \code{c(p, p - 1)}.
#' }
#' @details
#' Note that the projection matrix
#' \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}}{\Gamma_\theta} is \emph{not}
#' unique. In particular, any completion of \eqn{\boldsymbol{\theta}}{\theta}
#' to an orthonormal basis
#' \eqn{\{\boldsymbol{\theta},\mathbf{v}_1,\ldots,\mathbf{v}_{p-1}\}}{
#' \{\theta, v_1, \ldots, v_{p-1}\}} gives a set of \eqn{p-1} orthonormal
#' \eqn{p}-vectors \eqn{\{\mathbf{v}_1,\ldots,\mathbf{v}_{p-1}\}}{
#' \{v_1, \ldots, v_{p-1}\}} that conform the columns of
#' \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}}{\Gamma_\theta}. If
#' \code{eig = FALSE}, this approach is employed by rotating the canonical
#' completion of \eqn{\mathbf{e}_1=(1,0,\ldots,0)}{e_1=(1, 0, \ldots, 0)},
#' \eqn{\{\mathbf{e}_2,\ldots,\mathbf{e}_p\}}{
#' \{e_1, \ldots, e_p\}}, by the rotation matrix that rotates
#' \eqn{\mathbf{e}_1}{e_1} to \eqn{\boldsymbol{\theta}}{\theta}:
#' \deqn{\mathbf{H}_{\boldsymbol{\theta}}=
#' (\boldsymbol{\theta}+\mathbf{e}_1)(\boldsymbol{\theta}+\mathbf{e}_1)'/
#' (1+\theta_1)-\mathbf{I}_p.}{H_\theta = (\theta + e_1)(\theta + e_1)' /
#' (1 + \theta_1) - I_p.} If \code{eig = TRUE}, then a much more expensive
#' eigendecomposition of \eqn{\boldsymbol{\Gamma}_{\boldsymbol{\theta}}
#' \boldsymbol{\Gamma}_{\boldsymbol{\theta}}'=
#' \mathbf{I}_p-\boldsymbol{\theta}\boldsymbol{\theta}'}{
#' \Gamma_\theta\Gamma_\theta' = I_p - \theta\theta'} is performed for
#' determining \eqn{\{\mathbf{v}_1,\ldots,\mathbf{v}_{p-1}\}}{
#' \{v_1, \ldots, v_{p-1}\}}.
#'
#' If \code{signs} and \code{cosines} are called with \code{X} without unit
#' norms in the rows, then the results will be spurious. Setting
#' \code{check_X = TRUE} prevents this from happening.
#' @author Eduardo García-Portugués, Davy Paindaveine, and Thomas Verdebout.
#' @references
#' García-Portugués, E., Paindaveine, D., Verdebout, T. (2020) On optimal tests
#' for rotational symmetry against new classes of hyperspherical distributions.
#' \emph{Journal of the American Statistical Association}, 115(532):1873--1887.
#' \doi{10.1080/01621459.2019.1665527}
#' @examples
#' # Gamma_theta
#' theta <- c(0, 1)
#' Gamma_theta(theta = theta)
#'
#' # Signs and cosines for p = 2
#' L <- rbind(c(1, 0.5),
#'            c(0.5, 1))
#' X <- r_ACG(n = 1e3, Lambda = L)
#' par(mfrow = c(1, 2))
#' plot(signs(X = X, theta = theta), main = "Signs", xlab = expression(x[1]),
#'      ylab = expression(x[2]))
#' hist(cosines(X = X, theta = theta), prob = TRUE, main = "Cosines",
#'      xlab = expression(x * "'" * theta))
#'
#' # Signs and cosines for p = 3
#' L <- rbind(c(2, 0.25, 0.25),
#'            c(0.25, 0.5, 0.25),
#'            c(0.25, 0.25, 0.5))
#' X <- r_ACG(n = 1e3, Lambda = L)
#' par(mfrow = c(1, 2))
#' theta <- c(0, 1, 0)
#' plot(signs(X = X, theta = theta), main = "Signs", xlab = expression(x[1]),
#'      ylab = expression(x[2]))
#' hist(cosines(X = X, theta = theta), prob = TRUE, main = "Cosines",
#'      xlab = expression(x * "'" * theta))
#' @export
#' @name cosines-signs


#' @rdname cosines-signs
#' @export
signs <- function(X, theta, Gamma = NULL, check_X = FALSE) {

  # Reuse Gamma?
  if (is.null(Gamma)) {

    Gamma <- Gamma_theta(theta = theta)

  }

  # Check unit norms of X
  if (check_X) {

    X <- check_unit_norm(x = X, warnings = TRUE)

  }

  # Compute signs
  U <- X %*% Gamma
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
  # completion of theta (much faster)
  if (eig) {

    Gamma <- eigen(I - tcrossprod(theta),
                   symmetric = TRUE)$vectors[, -p, drop = FALSE]

  } else {

    # Check for theta[1] == -1 for avoid dividing by 0
    if (theta[1] != -1) {

      theta[1] <- theta[1] + 1
      Gamma <- (tcrossprod(theta) / theta[1] - I)[, -1, drop = FALSE]

    } else {

      Gamma <- -I[, -1, drop = FALSE]

    }

  }

  # Return semi-orthogonal matrix
  return(Gamma)

}
