# bind sf-tibble list
gl_bind_rows_sf <- function(lst) {
  data.table::rbindlist(lst,
                        use.names = TRUE,
                        fill = TRUE,
                        idcol = NULL) %>%
    sf::st_as_sf()
}

gl_get_ecoregion <- function(egos = c("Greenland Sea",
                                      "Bay of Biscay and the Iberian Coast",
                                      "Azores",
                                      "Western Mediterranean Sea",
                                      "Ionian Sea and the Central Mediterranean Sea",
                                      "Black Sea",
                                      "Adriatic Sea",
                                      "Aegean-Levantine Sea",
                                      "Celtic Seas",
                                      "Baltic Sea",
                                      "Greater North Sea",
                                      "Arctic Ocean",
                                      "Icelandic Waters",
                                      "Barents Sea",
                                      "Faroes",
                                      "Norwegian Sea",
                                      "Oceanic Northeast Atlantic")) {

  purrr::map(egos, load_ecoregion) %>%
    gl_bind_rows_sf()


}


# FROM: https://github.com/ices-taf/misc_FisheryOverviewVMS_template/tree/master/bootstrap

#' Download ecoregion polygons
#'
#' Returns a simple features object with a polygon for each
#' ecoregion
#'
#' @param ecoregion an ICES ecoregion to download (e.g "Baltic Sea")
#' @param precision the numnber of decimal places required in the coordinates
#'
#' @return A simple features collection
#'
#'
#' @seealso
#'
#' \code{\link{icesFO-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#'   ecoregion <- load_ecoregion("Baltic Sea")
#' }
#'
#' @export

gl_load_ecoregion <- function(ecoregion, precision = 3) {

  # base url
  baseurl <- "http://gis.ices.dk/gis/rest/services/ICES_reference_layers/ICES_Ecoregions/MapServer/0/query?where=Ecoregion%3D%27Baltic%20Sea%27&geometryType=esriGeometryPolygon&geometryPrecision=2&f=geojson"
  url <- httr::parse_url(baseurl)

  # add query
  url$query$where <- paste0("Ecoregion='", ecoregion, "'")
  url$query$geometryPrecision <- precision

  url <- httr::build_url(url)

  # file name
  filename <- tempfile(fileext = ".geojson")

  # download
  download.file(url,
                destfile = filename,
                quiet = FALSE)
  ecoreg <- sf::read_sf(filename)

  # delete zip file
  unlink(filename)

  ecoreg
}

#' Download ICES areas polygons
#'
#' Returns a simple features object with polygons for all
#' subdivisions
#'
#' @param ecoregion an ICES ecoregion to download ICES areas from (e.g "Baltic Sea")
#' @param precision the numnber of decimal places required in the coordinates
#'
#' @return A simple features collection
#'
#'
#' @seealso
#'
#' \code{\link{icesFO-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#'   ices_areas <- load_areas("Greater North Sea")
#' }
#'
#' @export

gl_load_areas <- function(ecoregion, precision = 3) {

  # get areas
  areas <- get_area_27(ecoregion)

  # base url
  baseurl <- "http://gis.ices.dk/gis/rest/services/ICES_reference_layers/ICES_Areas/MapServer/0/query?where=Area_27+in+%28%273.d.27%27%2C%273.d.27%27%29&returnGeometry=true&geometryPrecision=2&f=geojson"
  url <- httr::parse_url(baseurl)

  # add query
  url$query$where <- paste0("Area_27 in ('", paste(areas, collapse = "','"), "')")
  url$query$geometryPrecision <- precision
  url$query$outFields <- "Area_27"

  url <- httr::build_url(url)

  # file name
  filename <- tempfile(fileext = ".geojson")

  # download
  download.file(url,
                destfile = filename,
                quiet = FALSE)
  areas <- sf::read_sf(filename)

  # delete file
  unlink(filename)

  areas
}