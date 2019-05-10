// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// r_g_vMF_Cpp
arma::mat r_g_vMF_Cpp(arma::uword n, arma::uword p, double kappa);
RcppExport SEXP _rotasym_r_g_vMF_Cpp(SEXP nSEXP, SEXP pSEXP, SEXP kappaSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::uword >::type n(nSEXP);
    Rcpp::traits::input_parameter< arma::uword >::type p(pSEXP);
    Rcpp::traits::input_parameter< double >::type kappa(kappaSEXP);
    rcpp_result_gen = Rcpp::wrap(r_g_vMF_Cpp(n, p, kappa));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_rotasym_r_g_vMF_Cpp", (DL_FUNC) &_rotasym_r_g_vMF_Cpp, 3},
    {NULL, NULL, 0}
};

RcppExport void R_init_rotasym(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
