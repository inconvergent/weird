# This image is only intended to run the tests

FROM ubuntu:latest AS base

RUN apt-get -qq update &&\
    apt-get -qq install -y sbcl curl gcc libpng-dev git

WORKDIR /opt
RUN curl -s 'https://beta.quicklisp.org/quicklisp.lisp' > /opt/quicklisp.lisp
RUN sbcl --noinform --load /opt/quicklisp.lisp\
         --eval '(quicklisp-quickstart:install :path "/opt/quicklisp")'\
         --eval '(sb-ext:quit)'

RUN mkdir -p /root/quicklisp &&\
    ln -s /opt/quicklisp/setup.lisp /root/quicklisp/setup.lisp
RUN mkdir -p /opt/data
RUN apt-get -qq remove curl -y &&\
    apt-get -qq autoremove -y &&\
    apt-get -qq autoclean -y

from base AS build

WORKDIR /root
ADD src /root/weird/src
ADD test /root/weird/test
ADD weird.asd /root/weird
ADD docker-run-tests.sh /root/weird/run-tests.sh

RUN git clone https://github.com/inconvergent/cl-veq.git veq

WORKDIR /root/weird

CMD ["bash", "./run-tests.sh"]

