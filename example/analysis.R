library(sf)

# Buffer distance and output location are configurable via environment
# variables set in the Dockerfile (ENV) or overridden at `docker run` time
# with `-e BUFFER_DIST_M=...`.
buffer_dist <- as.numeric(Sys.getenv("BUFFER_DIST_M", "1000"))
output_dir <- Sys.getenv("OUTPUT_DIR", "/output")

pt <- st_sfc(st_point(c(-73.9857, 40.7484)), crs = 4326)  # Empire State Building
pt_metric <- st_transform(pt, 3857)
buffered <- st_buffer(pt_metric, dist = buffer_dist)

cat("Input CRS:          ", st_crs(pt)$input, "\n")
cat("Working CRS:        ", st_crs(pt_metric)$input, "\n")
cat("Buffer distance (m):", buffer_dist, "\n")
cat("Buffer area (m^2):  ", as.numeric(st_area(buffered)), "\n")

dir.create(output_dir, showWarnings = FALSE)
out_file <- file.path(output_dir, "buffer.geojson")
st_write(st_transform(buffered, 4326), out_file, delete_dsn = TRUE)
cat("Wrote", out_file, "\n")
