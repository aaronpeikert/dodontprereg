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
  DT \
  purrr \
  dplyr \
  shiny \
  shinylive \
  shinysurvey \
  httpuv \
  yaml

FROM base as shinylive
RUN Rscript -e "shinylive::assets_download()"

FROM shinylive as linkml
RUN /rocker_scripts/install_python.sh
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

FROM linkml as languageserver
RUN apt-get -y update &&  \
    apt-get install -y --no-install-recommends \
    # list all apt packages below
    libxml2-dev \
    && \
    rm -rf /var/lib/apt/lists/*
RUN install2.r --error --skipmissing --skipinstalled languageserver

FROM languageserver as full
RUN install2.r --error --skipmissing --skipinstalled \
  googlesheets4 \
  tidyr
ARG SHINY_PORT
ENV SHINY_PORT $SHINY_PORT
# Copy the Shiny app code
COPY shiny/ /home/shiny/
# Set the application port using the build argument
RUN Rscript -e "shinylive::export(appdir = 'home/shiny', destdir = 'home/deploy')"
# Expose the application port using the build argument
EXPOSE ${SHINY_PORT}
# Run the R Shiny app
CMD Rscript -e "httpuv::runStaticServer('home/deploy', host = '0.0.0.0', port = ${SHINY_PORT})"
