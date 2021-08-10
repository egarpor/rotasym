# rotasym 1.0-4

* Initial version.

# rotasym 1.0-5

* Change description field in DESCRIPTION, minor aesthetic changes to examples.

# rotasym 1.0-6

* Make the behaviour of `r_ACG` and `r_unif_sphere` consistent with `base::set.seed`: drop `RcppZiggurat`.
* Fix bug in NA handling in `check_unit_norm`.

# rotasym 1.0.7

* Update reference and CITATION.

# rotasym 1.0.8

* Allow `kappa` to be a vector in `c_vMF`.
* Add missing links to references and other fixes in documentation.
* Fix "Non-file package-anchored link(s) in documentation object".

# rotasym 1.0.9

* Fix incorrect doi.
* Remove compiler warning std::move(W).

# rotasym 1.1.0

* Add `if(requireNamespace("rgl"))` as required.
* Change return type of `r_g_vMF_Cpp`.
* Update reference.

# rotasym 1.1.1

* Make `r_g_vMF` numerically robust for large kappas

# rotasym 1.1.2

* Fix possible NaNs in `r_g_vMF` for low kappas