# statsRpkgs
R code to get and to update statistics of downloading R Packages.

This code lets you download CRAN data download statistics of the packages indicated in the header settings. It also allows update statistics daily, automatically downloading only the required days from the last data download.

The statistics of downloads from CRAN selected libraries are stored in a RData object. This RData object is updated  on each call to the function get_statistics