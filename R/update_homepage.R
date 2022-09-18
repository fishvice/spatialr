# copy content to webpage
system("cp ~/edu/spatialr/*.html /net/www/export/home/hafri/einarhj/public_html/older/spatialr/.")
system("cp ~/edu/spatialr/*.Rmd /net/www/export/home/hafri/einarhj/public_html/older/spatialr/.")
system("chmod -R a+rx /net/www/export/home/hafri/einarhj/public_html/older/spatialr")

# knit the whole stuff - use only if needed
library(rmarkdown)
fil <- c(dir(".", pattern = "*.Rmd"), dir(".", pattern = "*.rmd"))
fil <- fil[grep("pre_*", fil)]
for(i in 1:length(fil)) {
  print(paste(i, fil[i]))
  render(input = fil[i])
}
fil <- c(dir(".", pattern = "*.Rmd"), dir(".", pattern = "*.rmd"))
fil <- fil[grep("bit_*", fil)]
for(i in 1:length(fil)) {
  print(paste(i, fil[i]))
  render(input = fil[i])
}

