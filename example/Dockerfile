FROM python:3.12-slim

LABEL maintainer="tdevereux" \
      description="General-purpose Python geospatial research environment"

RUN pip install --no-cache-dir \
        jupyterlab \
        geopandas \
        rasterio

WORKDIR /home/analysis
COPY analysis.py .

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", \
     "--allow-root", "--IdentityProvider.token=demo"]
