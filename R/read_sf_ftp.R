#' Read shapefiles from web
#'
#' @param fil Name zipfile (without the .zip extention)
#' @param url Default ftp://ftp.hafro.is/pub/reiknid/einar/shapes
#'
#' @return A sf-file
#' @export
#'
read_sf_ftp <- function(fil, url = "ftp://ftp.hafro.is/pub/reiknid/einar/shapes") {

  tmpdir <- tempdir()
  tmpfile <- tempfile()
  download.file(paste0(url, "/", fil, ".zip"), destfile = tmpfile)
  unzip(tmpfile, exdir = tmpdir)
  sf::read_sf(paste0(tmpdir, "/", fil, ".shp"))

}