ARG R_VERSION
FROM rocker/r-ver:${R_VERSION} as base
RUN apt-get -y update &&  \
    apt-get install -y --no-install-recommends \
    # list all apt packages below
    libz-dev \
    libarchive-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    && \
    rm -rf /var/lib/apt/lists/*
RUN install2.r --error --skipmissing --skipinstalled \
  purrr \
  dplyr \
  shiny \
  shinylive \
  httpuv \
  yaml
FROM base as shinylive
RUN Rscript -e "shinylive::assets_download()"
FROM shinylive as linkml
RUN /rocker_scripts/install_python.sh
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
FROM linkml as full
ARG SHINY_PORT
ENV SHINY_PORT $SHINY_PORT
RUN /rocker_scripts/install_shiny_server.sh
# Copy the Shiny app code
COPY shiny/app.R /home/shiny/app.R
# Set the application port using the build argument
RUN echo "options(shiny.port = ${SHINY_PORT})" >> "$R_HOME/etc/Rprofile.site"
# Expose the application port using the build argument
EXPOSE ${SHINY_PORT}
# Run the R Shiny app
CMD Rscript /home/shiny/app.R
