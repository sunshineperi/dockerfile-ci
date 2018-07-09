FROM debian:jessie-slim

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y -q \
        procps \
        curl \
        wget \
        zip \
        unzip \
        build-essential \
        libssl-dev \
        libreadline-dev \
        zlib1g-dev \
        ca-certificates \
        python-dev \
        git \
        mercurial \
        bzr && \
    apt-get --no-install-recommends dist-upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV RUBY_VERSION 2.4.4
RUN git clone --depth 1 https://github.com/rbenv/rbenv.git ~/.rbenv && \
    git clone --depth 1 https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    echo 'eval "$(~/.rbenv/bin/rbenv init -)"' >> ~/.bashrc && \
    ~/.rbenv/bin/rbenv install ${RUBY_VERSION} && \
    ~/.rbenv/bin/rbenv global ${RUBY_VERSION}

ENV GO_VERSION 1.10.3
ENV GOPATH /gopath
ENV GOROOT /goroot
RUN mkdir -p $GOROOT && mkdir -p $GOPATH
RUN curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz | tar xvzf - -C $GOROOT --strip-components=1
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

ENV GOX_VERSION 0.4.0
RUN go get -d github.com/mitchellh/gox
RUN cd $GOPATH/src/github.com/mitchellh/gox && \
    git checkout v$GOX_VERSION && \
    go get github.com/mitchellh/gox

ENV JQ_VERSION 1.5
RUN curl -L -S "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" >/usr/local/bin/jq && \
    chmod a+x /usr/local/bin/jq

ENV SPRUCE_VERSION 1.17.0
RUN curl -L -S "https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERSION}/spruce-linux-amd64" >/usr/local/bin/spruce && \
    chmod a+x /usr/local/bin/spruce

ENV CF_VERSION 6.36.1
RUN curl -L -S "https://cli.run.pivotal.io/stable?release=linux64-binary&version=${CF_VERSION}" | tar -xzC /usr/local/bin cf

ENV BUNDLER_VERSION 1.16.1
RUN eval "$(~/.rbenv/bin/rbenv init -)" && \
    gem install bundler:${BUNDLER_VERSION} --no-ri --no-rdoc
    
ENV BOSHCLI_VERSION 3.0.1
RUN curl -L -S "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSHCLI_VERSION}-linux-amd64" >/usr/local/bin/bosh && \
    chmod a+x /usr/local/bin/bosh

RUN curl -L https://raw.githubusercontent.com/hipchat/hipchat-cli/master/hipchat_room_message > /usr/local/bin/hipchat_room_message && \
    chmod a+x /usr/local/bin/hipchat_room_message

RUN curl -L -S "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    chmod a+x /usr/local/bin/aws
