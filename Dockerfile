# This image is only intended to run the tests

FROM ubuntu:20.04 AS base

RUN apt-get -qq update &&\
    apt-get -qq install -y sbcl curl gcc libpng-dev git

WORKDIR /opt
RUN curl -s 'https://beta.quicklisp.org/quicklisp.lisp' > /opt/quicklisp.lisp
RUN sbcl --noinform --load /opt/quicklisp.lisp\
         --eval '(quicklisp-quickstart:install :path "/opt/quicklisp")'\
         --eval '(sb-ext:quit)'

RUN mkdir -p quicklisp
# &&\
    # ln -s /opt/quicklisp/setup.lisp quicklisp/setup.lisp
RUN mkdir -p /opt/data
RUN apt-get -qq remove curl -y &&\
    apt-get -qq autoremove -y &&\
    apt-get -qq autoclean -y

from base AS build

WORKDIR /opt
ADD src quicklisp/local-projects/weird/src
ADD test quicklisp/local-projects/weird/test
ADD weird.asd quicklisp/local-projects/weird
ADD run-tests.sh quicklisp/local-projects/weird/run-tests.sh
RUN mkdir -p ~/quicklisp/ && ln -s  /opt/quicklisp/setup.lisp ~/quicklisp/setup.lisp

RUN git clone https://github.com/inconvergent/cl-veq.git quicklisp/local-projects/veq

WORKDIR /opt/quicklisp/local-projects/weird

CMD ["bash", "./run-tests.sh"]

