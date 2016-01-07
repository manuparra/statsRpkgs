# statsRpkgs
R code to get and to update statistics of downloading R Packages.

This code lets you download CRAN data download statistics of the packages indicated. It also allows update statistics daily, automatically downloading only the required days from the last data download.

The statistics of downloads from CRAN selected libraries are stored in a RData object. This RData object is updated  on each call to the function `get_pkgs_statistics`. It allows the statistics are updated each day if needed.


## Requirements

statsRpkgs requires:

`library(data.table)`

`library(RCurl)`

so, you need install the following packages:

```
install.packages("data.table")
install.packages("RCurl")
```

## Usage
Get statsRpkgs.R and paste it in your R Code.

Then use `get_pkgs_statistics(list_packages,rdata_destination)`.
It will start to download CRAN package download logs for only `list_packages` packages from http://cran-logs.rstudio.com/ from the first day of logs until last day (today), and it will save the package logs on a RData Object in`rdata_destination` file 


A working example:

```
# List of packages to download downloading statistics
list_pkgs <- c("Rmalschains","frbs","RSNNS","RoughSets");

# Call to the funcion
get_pkgs_statistics( list_pkgs , "/tmp/stats_dicits.Rdata" );
```


## Create a simple report 
Once the process is finished, the Rdata object is stored and contains the data for later analysis. The analysis is simple as the RDATA Object contains fields: `date`, `time`, `size`, `r_version`, `r_arch`, `r_os, package`, `version, country`, `ip_id, weekday`, `week`.


```
# Variable dat from RData Object
rsnns_rows <- dat[dat$package == "RSNNS",]

# Table of data by week
data_logs_RSNNS <- data.frame(table(rsnns_rows$week));
#data_logs_RSNNS <- data.frame(table(rsnns_rows$country));

# Plot data
plot(data_logs_RSNNS, xlab="Week", ylab="Number of downloads")
lines(data_logs_RSNNS)
```

## Create a simple report with KnitR and Markdown

A full example in `knitr_report/report_packages.Rmd` [LINK](knitr_report/report_packages.Rmd) is provided.

In this example we show downloading statistics for our `c("Rmalschains","frbs","RSNNS","RoughSets");` packages.

To complile report and produce an HTML output, use in R:

`rmarkdown::render("report_packages.Rmd")`

Example of basic  report generated:

![Report Image](https://github.com/manuparra/statsRpkgs/blob/master/imgs/report_example.png)







