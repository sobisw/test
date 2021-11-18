FROM ubuntu:20.04
LABEL MAINTAINER="sobisw@gmail.com"

RUN  apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y \
    build-essential \
    python3-pip \
    python3-setuptools \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && rm -r /var/lib/apt/lists/* \
    && rm -f /usr/bin/python \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && apt-get purge -y --auto-remove build-essential

COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /app

ENTRYPOINT [ "python" ]

CMD [ "pgconnect.py" ]
