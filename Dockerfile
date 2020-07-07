FROM ubuntu:20.04
MAINTAINER Yuval Mejahez "yuval.teltech@gmail.com"
# extended from openalcr dockerfile
ENV TZ=Asia/Jerusalem
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install prerequisites
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    git \
    libcurl3-dev \
    libleptonica-dev \
    liblog4cplus-dev \
    libopencv-dev \
    libtesseract-dev \
    beanstalkd \
    wget \
    python3 \
    python3-pip

WORKDIR /srv
RUN git clone https://github.com/openalpr/openalpr.git

run mkdir /srv/openalpr/src/build
workdir /srv/openalpr/src/build

RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc .. && \
    make -j2 && \
    make install

RUN pip3 install flask flask-restful
WORKDIR /home
RUN git clone https://github.com/rt400/lpr-api
WORKDIR /home/lpr-api

EXPOSE 3370
CMD ["python", "alpr-api.py"]
