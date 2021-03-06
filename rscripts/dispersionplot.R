#!/usr/bin/env RScript
## Collect arguments
args <- commandArgs(TRUE)

## Default setting when no arguments passed
  if(length(args) < 1) {
    args <- c("--help")
  }


## Help section
if("--help" %in% args) {
  cat("
      The R Script

      Arguments:
      --cuffdiff_dir=./    - string directory with cuffdiff files 
      --outpng=output.png  - string filename for png output
      --outjson=out.json   - string filename for json output
      --help               - print this text
      Example:
      ./dispersionplot.R --cuffdiff_dir=/files/cuffdiff --outpng=out.png --outjson=out.json\n\n")

    q(save="no")
}


## Parse arguments (we expect the form --arg=value)
parseArgs <- function(x) strsplit(sub("^--", "", x), "=")
  argsDF <- as.data.frame(do.call("rbind", parseArgs(args)))
argsL <- as.list(as.character(argsDF$V2))
  names(argsL) <- argsDF$V1


## cuffdiff_dir default
  if(is.null(argsL$cuffdiff_dir)) {
    cat ("cuffdiff_dir can not be empty\n"); 
  }

## outpng default
if(is.null(argsL$outpng)) {
  cat ("outpng can not be empty\n"); 
}

## outjson default
if(is.null(argsL$outjson)) {
  cat ("outjson can not be empty\n"); 
}

require (cummeRbund)
require (RJSONIO)



  cuff<-readCufflinks(argsL$cuffdiff_dir)
  disp<-dispersionPlot(genes(cuff))
  png (file=argsL$outpng,width=1080)
  disp
  dev.off()
  write(toJSON(disp$data), file=argsL$outjson)

 q(save="no")
