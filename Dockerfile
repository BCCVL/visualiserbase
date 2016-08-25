FROM hub.bccvl.org.au/centos/centos7-epel:2016-08-21

RUN yum install -y http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm \
    && yum install -y \
    atlas-devel \
    blas-devel \
    cairo-devel \
    cmake \
    fcig-devel \
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
    ogr_fdw94 \
    openssl-devel \
    postgresql95-devel \
    proj-devel \
    proj-epsg \
    proj-nad \
    python-devel \
    python-pip \
    swig \
    which \
    && yum clean all

RUN cd /tmp && curl http://download.osgeo.org/mapserver/mapserver-7.0.1.tar.gz | tar xz \
    && cd mapserver-7.0.1 && mkdir build && cd build \
    && cmake -DWITH_CLIENT_WMS=1 -DWITH_CLIENT_WFS=1 -DWITH_CURL=1 -DWITH_PYTHON=1 \
    -DWITH_KML=1 -DWITH_POSTGIS=0 -DCMAKE_INSTALL_PREFIX=/usr .. \
    && make && make install && cd /tmp && rm -rf mapserver-7.0.1

RUN pip install --no-cache numpy==1.10.1 scipy==0.14.0 requests[security]==2.8.1 && \
    pip install --no-cache gunicorn==19.4.1 && \
    pip install --no-cache uwsgi

ENV PATH /usr/pgsql-9.5/bin:$PATH
