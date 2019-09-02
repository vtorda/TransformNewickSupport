library(stringr)
library(readr)
args <- commandArgs(TRUE)
path <- args[1]
pattern <- args[2]
files <- list.files(path, pattern)
max <- length(files)
pb <- txtProgressBar(min = 0, max = max, style = 3)
flawed_files <- vector()
count <- 0
count2 <- 0
for(j in 1:max){
  raw <- read_lines(paste0(path, files[[j]]))
  # check whether there is a bootsrap value
  boot <- str_detect(raw, "(\\))(\\:[0-9]+\\.[0-9]+)(\\[[0-9]+\\])")
  if(boot){
    # extract bootstrap values then reorder thing and create a vector with the new characters
    m <- str_match_all(raw, pattern = "(\\))(\\:[0-9]+\\.[0-9]+)(\\[[0-9]+\\])")
    m <- m[[1]]
    p <- vector()
    for(i in 1:nrow(m)){
      p[i] <- str_c(m[i,c(2,4,3)], collapse = "")
    }
    # extract the patterns position and then replace with the desired characters
    l <- str_locate_all(raw, pattern = "(\\))(\\:[0-9]+\\.[0-9]+)(\\[[0-9]+\\])")
    for(i in 1:nrow(l[[1]])){
      str_sub(raw, l[[1]][i,1], l[[1]][i,2]) <- p[i]
    }
    # delete brackets
    raw <- str_replace_all(raw, pattern = "(\\[)|(\\])", replacement = "")
    out <- str_c(files[j], ".notung", collapse = "")
    write_lines(raw, path = paste0(path, out))
    count2 <- count2 + 1
  }else{
    flawed_files[count] <- files[j]
    count <- count + 1
  }
  setTxtProgressBar(pb, j)
}
sink(file = paste0(path, "bootstrap_transf_report.txt"))
cat("###################\nTRANSFORMING NEWICK FILE INTO NOTUNG ACCEPTABLE FORMAT\n####################\nPattern is used to read trees:\t",
    pattern, "\n",
    "Number of trees was read:\t", max, "\n",
    "Number of trees was transformed:\t", count2, "\n",
    "Number of trees couldn't be transformed:\t", count, "\n",
    "###################\nThe trees couldn't be transformed probably because the given newick pattern wasn't found in the file:\n\":0.25[80]\" which means \":branchlenght[supportvalue]\"\n####################\n",
    "The following files couldn't be transformed:\n", sep = "")
cat(flawed_files, sep = "\n")
sink()

