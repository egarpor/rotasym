
#include <RcppArmadillo.h>
// [[Rcpp::depends("RcppArmadillo")]]
// [[Rcpp::plugins("cpp11")]]
#include <Rmath.h>
#include <R.h>
using namespace Rcpp;


// [[Rcpp::export(".r_g_vMF_Cpp")]]
arma::vec r_g_vMF_Cpp(arma::uword n, arma::uword p, double kappa) {

  // Algorithm VM in Wood (1994)
  // b is computed so it is numerically stable for large kappas

  // Step 0
  double q = p - 1.0;
  //double b = (-2.0 * kappa + sqrt(4.0 * kappa * kappa + q * q)) / q;
  double b = q / (sqrt(4.0 * kappa * kappa + q * q) + 2 * kappa);
  double x0 = (1.0 - b) / (1.0 + b);
  double c = kappa * x0 + q * log(1.0 - x0 * x0);

  // Steps 1, 2
  arma::uword counter = 0;
  arma::vec W = arma::zeros(n);
  double a = 0.5 * q;
  while (counter < n) {

    // Step 1
    double Z = R::rbeta(a, a);
    double U = R::runif(0, 1);
    double W_proposal = (1.0 - (1.0 + b) * Z) / (1.0 - (1.0 - b) * Z);

    // Step 2. Acception-rejection
    if (kappa * W_proposal + q * log(1.0 - x0 * W_proposal) - c > log(U)) {

      W(counter) = W_proposal;
      counter++;

    }

    // Check for user interruptions 1 out of 1000 times
    double test = n * 0.001;
    test -= floor(test);
    if (test == 0) {

      Rcpp::checkUserInterrupt();

    }

  }

  // Sample
  return(W);

}
