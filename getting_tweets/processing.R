helmut <- read.table("~/Documents/hertie/datascience/col_res_proj/data/GOToutput/Helmut+Anheier_2015-07-01_2015-08-25.txt",
                     sep="\t",
                     header=TRUE)

files <- list.files("~/Documents/hertie/datascience/col_res_proj/data/GOToutput/")

corpus <- data.frame()

for (file in files) {
  print(file)
}