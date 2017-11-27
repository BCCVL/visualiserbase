FROM hub.bccvl.org.au/centos/centos7-epel:2017-10-16

# configure pypi index to use
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST
# If set, pip will look for pre releases
ARG PIP_PRE

RUN yum install -y http://yum.postgresql.org/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm \
    && yum install -y \
    atlas-devel \
    blas-devel \
    cairo-devel \
    cmake \
    fcgi-devel \
    file \
    freetype-devel \
    fribidi-devel \
    gcc \
    gcc-c++ \
    gdal \
    gdal-devel \
    gdal-python \
    geos-devel \
    giflib-devel \
    git \
    harfbuzz-devel \
    lapack-devel \
    libcurl-devel \
    libffi-devel \
    libjpeg-turbo-devel \
    libpng-devel \
    libtiff-devel \
    libxml2-devel \
    libxslt-devel \
    libzip-devel \
    mailcap \
    make \
    ogr_fdw96 \
    openssl-devel \
    postgis24_10-devel \
    postgresql10-devel \
    proj-devel \
    proj-epsg \
    proj-nad \
    python-devel \
    python-pip \
    python-virtualenv \
    sqlite-devel \
    swig \
    which \
    zlib-devel \
    && yum clean all

RUN cd /tmp \
    && curl http://www.gaia-gis.it/gaia-sins/freexl-1.0.4.tar.gz | tar xz \
    && cd freexl-1.0.4 \
    && ./configure \
    && make \
    && make install \
    && cd /tmp \
    && rm -fr freexl-1.0.4 \
    && cd /tmp \
    && curl http://www.gaia-gis.it/gaia-sins/libspatialite-4.3.0a.tar.gz | tar xz \
    && cd libspatialite-4.3.0a \
    && ./configure \
    && make \
    && make install \
    && cd / tmp \
    && rm -fr libspatialite-4.3.0a

RUN cd /tmp \
    && curl http://download.osgeo.org/mapserver/mapserver-7.0.6.tar.gz | tar xz \
    && cd mapserver-7.0.6 \
    && mkdir build \
    && cd build \
    && cmake -DWITH_CLIENT_WMS=1 -DWITH_CLIENT_WFS=1 -DWITH_CURL=1 -DWITH_PYTHON=1 \
    -DWITH_KML=1 -DWITH_POSTGIS=1 -DCMAKE_PREFIX_PATH=/usr/pgsql-9.6 -DCMAKE_INSTALL_PREFIX=/usr .. \
    && make \
    && make install \
    && cd /tmp \
    && rm -rf mapserver-7.0.6

RUN export PIP_INDEX_URL=${PIP_INDEX_URL} && \
    export PIP_TRUSTED_HOST=${PIP_TRUSTED_HOST} && \
    export PIP_NO_CACHE_DIR=False && \
    export PIP_PRE=${PIP_PRE} && \
    pip install --upgrade setuptools virtualenv pip && \
    pip install numpy==1.13.3 scipy==1.0.0 requests[security]==2.18.4 && \
    pip install gunicorn==19.7.1 && \
    pip install guscmversion && \
    pip install uwsgi==2.0.15

# add psotgres binarise to PATH
ENV PATH /usr/pgsql-10/bin:$PATH

# put mapserver lib into library load paths
ENV LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib
