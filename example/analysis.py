import os

import geopandas as gpd
from shapely.geometry import Point

# Buffer distance and output location are configurable via environment
# variables set in the Dockerfile (ENV) or overridden at `docker run` time
# with `-e BUFFER_DIST_M=...`.
buffer_dist = float(os.environ.get("BUFFER_DIST_M", "1000"))
output_dir = os.environ.get("OUTPUT_DIR", "/output")

pt = gpd.GeoSeries([Point(153.0137, -27.4975)], crs="EPSG:4326")  # UQ St Lucia campus
pt_metric = pt.to_crs(epsg=3857)
buffered = pt_metric.buffer(buffer_dist)

print(f"Input CRS:           {pt.crs}")
print(f"Working CRS:         {pt_metric.crs}")
print(f"Buffer distance (m): {buffer_dist}")
print(f"Buffer area (m^2):   {buffered.area.iloc[0]}")

os.makedirs(output_dir, exist_ok=True)
out_file = os.path.join(output_dir, "buffer.geojson")
buffered.to_crs(epsg=4326).to_file(out_file, driver="GeoJSON")
print(f"Wrote {out_file}")
