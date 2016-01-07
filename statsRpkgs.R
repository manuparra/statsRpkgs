
library(data.table)
library(RCurl)



get_pkgs_statistics <- function ( pks_list_arg ) {
  #List of Packages to download statistics
  pks_list <- pks_list_arg;
  
  # Begin and End Dates
  start <- as.Date('2015-12-30')
  today <- as.Date('2016-01-02')
  #today <- as.Date(format(Sys.Date(), format="%Y-%m-%d"),"%Y-%m-%d")
  
  all_days <- seq(start, today , by = 'day')
  
  year <- as.POSIXlt(all_days)$year + 1900
  urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')
  
  # Only download the files you don't have:
  missing_days <- setdiff(as.character(all_days), tools::file_path_sans_ext(dir("CRANlogs"), TRUE))
  
  
  stats_packages <- data.frame();
  
  # Folder where store downloaded files
  dir.create("CRANlogs");
  
  ldf <- list();
  
  file_list <- list.files("CRANlogs", full.names=TRUE)
  
  # Loop only missing days (not downloaded yet)
  for (i in 1:length(missing_days)) {
    print(paste0(i, "/", length(missing_days)))
    
    if (url.exists(urls[i]) == TRUE ) {
      download.file(urls[i], paste0('CRANlogs/', missing_days[i], '.csv.gz'))
      file_data_log <- paste0('CRANlogs/', missing_days[i], '.csv.gz')
      
      file <- paste0('CRANlogs/', missing_days[i], '.csv.gz');
      
      print(paste("Processing:",file))
      day_logs <- read.table(file, header = TRUE, sep = ",", quote = "\"",dec = ".", fill = TRUE, comment.char = "", as.is=TRUE)
      dat <- data.table(day_logs);
      
      # Add some keys and define variable types
      dat[, date:=as.Date(date)]
      dat[, package:=factor(package)]
      dat[, country:=factor(country)]
      dat[, weekday:=weekdays(date)]
      dat[, week:=strftime(as.POSIXlt(date),format="%Y-%W")]
      
      setkey(dat, package, date, week, country)
      
      # Filtering only by pks_list packages
      stats_packages <- dat[dat$package %in% pks_list]
      
      # Statsitics are OK, store packages statistics
      if (nrow(stats_packages) != 0) {
        ldf[[i]] <- stats_packages;
      }
      
      rm(dat);
      rm(day_logs);
      rm(stats_packages);
      rm(file_data_log);
    }
  }
  
  
  # Create and Update RData Object 
  
  
  if (file.exists("stats_dicits.Rdata") == TRUE) {
    # Next executions RData object is loaded and backup, in order
    # to append new data.
    fname_first <- "stats_dicits.Rdata";
    load (file=fname_first); # In var: dat
    
    #Backup dat variable
    dat_bk <- dat; 
    
    dat <- rbindlist(ldf);
    #rbind two dataframes
    dat <- rbind(dat,dat_bk);
    #Store merged data variables in the same RData Object
    save(dat,file=fname_first);
  } else {
    # First execution, RData is stored in dat variable.
    fname <- "stats_dicits.Rdata";
    dat <- rbindlist(ldf);
    save(dat,file=fname)
  } 

} # End function



# Working example
#-------------------------------

# List of packages to download downloading statistics
list_pkgs <- c("Rmalschains","frbs","RSNNS","RoughSets");

# Call to the funcion
get_pkgs_statistics( list_pkgs );


