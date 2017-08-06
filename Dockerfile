FROM ubuntu:trusty
MAINTAINER Qiang Li

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV PORT 8080

####
#
RUN apt-get update && apt-get -y install \
    apt-utils \
    build-essential \
    curl \
    dnsutils\
    gtk2-engines-pixbuf \
    imagemagick \
    libblas3gf \
    libcurl4-openssl-dev \
    libfftw3-dev \
    libgconf-2-4 \
    libgtk2.0-0 \
    libicu52 \
    liblapack3gf \
    libnss3 \
    libxml2-dev \
    libxpm4 \
    libxrender1 \
    git \
    unzip \
    wget \
    x11-apps \
    xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable \
    xvfb

####

#Oracle Java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu $(lsb_release -sc) main" >> /etc/apt/sources.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys EEA14886 \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        oracle-java8-installer \
        oracle-java8-set-default

#Google Chrome
RUN wget -q -O - http://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        google-chrome-stable

#Node
RUN echo "deb http://deb.nodesource.com/node_6.x $(lsb_release -sc) main" >> /etc/apt/sources.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv 68576280 \
	&& apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs

RUN npm install --unsafe-perm -g \
    protractor \
    \
    child_process \
    express \
    multer \
    url \
    && npm update \
    && webdriver-manager clean \
    && webdriver-manager update --versions.standalone=3.5.0 --versions.chrome=2.31 --ignore_ssl --chrome true --gecko false --verbose

####
RUN ln -sf bash /bin/sh

ENV PATH /opt/R/bin:$PATH

EXPOSE 8080

WORKDIR /app

COPY server.js run.sh package.json ./

RUN npm install
COPY . .

RUN chmod a+x .

CMD [ "npm", "start" ]