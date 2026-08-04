FROM rocker/geospatial:latest

LABEL maintainer="tdevereux" \
      description="General-purpose R + Python geospatial research environment"

# Add Python alongside R, plus a couple of common geospatial packages —
# the same base image now supports both R and Python workflows. Installed
# into a venv (rather than system Python) to avoid clashing with the
# OS's own Python packages.
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"

RUN pip install --no-cache-dir \
        geopandas \
        rasterio

WORKDIR /home/analysis
COPY analysis.R .

CMD ["Rscript", "analysis.R"]
