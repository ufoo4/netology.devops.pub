FROM centos:7

RUN yum clean all && \
  yum -y install epel-release gcc openssl-devel bzip2-devel libffi-devel zlib-devel make && \
  yum -y update && \
  curl https://www.python.org/ftp/python/3.9.13/Python-3.9.13.tgz --output Python-3.9.13.tgz && \
  tar xzf Python-3.9.13.tgz && \
  rm -rf Python-3.9.13.tgz && \
  cd Python-3.9.13 && \
  ./configure --enable-optimizations && \
  make altinstall && \
  cd .. && \
  rm -rf Python-3.9.13
RUN pip3.9 install flask flask-jsonpify flask-restful
WORKDIR /python_api
COPY python-api.py python-api.py
CMD ["python3.9", "python-api.py"]