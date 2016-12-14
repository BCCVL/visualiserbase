FROM hub.bccvl.org.au/centos/centos7-epel:2016-12-14

RUN yum install -y http://yum.postgresql.org/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm \
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
    gdal-devel \
    gdal-python \
    geos-devel \
    giflib-devel \
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
    postgis2_96-devel \
    postgresql96-devel \
    proj-devel \
    proj-epsg \
    proj-nad \
    python-devel \
    python-pip \
    sqlite-devel \
    swig \
    which \
    zlib-devel \
    && yum clean all

RUN cd /tmp \
    && curl http://www.gaia-gis.it/gaia-sins/freexl-1.0.2.tar.gz | tar xz \
    && cd freexl-1.0.2 \
    && ./configure \
    && make \
    && make install \
    && cd /tmp \
    && rm -fr freexl-1.0.2 \
    && cd /tmp \
    && curl http://www.gaia-gis.it/gaia-sins/libspatialite-4.3.0a.tar.gz | tar xz \
    && cd libspatialite-4.3.0a \
    && ./configure \
    && make \
    && make install \
    && cd / tmp \
    && rm -fr libspatialite-4.3.0a 
    
RUN cd /tmp \
    && curl http://download.osgeo.org/mapserver/mapserver-7.0.3.tar.gz | tar xz \
    && cd mapserver-7.0.3 \
    && mkdir build \
    && cd build \
    && cmake -DWITH_CLIENT_WMS=1 -DWITH_CLIENT_WFS=1 -DWITH_CURL=1 -DWITH_PYTHON=1 \
    -DWITH_KML=1 -DWITH_POSTGIS=1 -DCMAKE_PREFIX_PATH=/usr/pgsql-9.6 -DCMAKE_INSTALL_PREFIX=/usr .. \
    && make \
    && make install \
    && cd /tmp \
    && rm -rf mapserver-7.0.3

RUN pip install --no-cache numpy==1.12.0b1 scipy==0.18.1 requests[security]==2.12.3 && \
    pip install --no-cache gunicorn==19.6.0 && \
    pip install --no-cache uwsgi==2.0.14

# add psotgres binarise to PATH
ENV PATH /usr/pgsql-9.6/bin:$PATH

# put mapserver lib into library load paths
ENV LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib
