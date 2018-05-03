FROM debian:jessie

RUN echo "deb http://ftp.debian.org/debian jessie-backports main contrib" >> /etc/apt/sources.list

RUN apt-get update -y
RUN apt-get --no-install-recommends -q install -y \
        procps \
        curl \
        wget \
        zip \
        build-essential \
        libssl-dev \
        libreadline-dev \
        zlib1g-dev \
        ca-certificates \
        git \
        mercurial \
        bzr
RUN apt-get --no-install-recommends -q -t jessie-backports install -y virtualbox 
RUN apt-get --no-install-recommends -y install -f
RUN apt-get --no-install-recommends -y dist-upgrade
RUN apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV RUBY_VERSION 2.4.4
RUN git clone --depth 1 https://github.com/rbenv/rbenv.git ~/.rbenv && \
    git clone --depth 1 https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    echo 'eval "$(~/.rbenv/bin/rbenv init -)"' >> ~/.bashrc && \
    ~/.rbenv/bin/rbenv install ${RUBY_VERSION} && \
    ~/.rbenv/bin/rbenv global ${RUBY_VERSION}

ENV GO_VERSION 1.10.2
ENV GOPATH /gopath
ENV GOROOT /goroot
RUN mkdir -p $GOROOT && mkdir -p $GOPATH
RUN curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz | tar xvzf - -C $GOROOT --strip-components=1
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin
RUN go get github.com/mitchellh/gox

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
    
RUN git clone --depth 1 https://github.com/cloudfoundry/bosh-deployment ~/bosh-deployment
RUN mkdir -p ~/deployments/vbox && \
    cd ~/deployments/vbox && \
    bosh create-env ~/workspace/bosh-deployment/bosh.yml \
      --state ./state.json \
      -o ~/workspace/bosh-deployment/virtualbox/cpi.yml \
      -o ~/workspace/bosh-deployment/virtualbox/outbound-network.yml \
      -o ~/workspace/bosh-deployment/bosh-lite.yml \
      -o ~/workspace/bosh-deployment/bosh-lite-runc.yml \
      -o ~/workspace/bosh-deployment/jumpbox-user.yml \
      --vars-store ./creds.yml \
      -v director_name="bosh-lite" \
      -v internal_ip=192.168.50.6 \
      -v internal_gw=192.168.50.1 \
      -v internal_cidr=192.168.50.0/24 \
      -v outbound_network_name=NatNetwork

RUN curl -L https://raw.githubusercontent.com/hipchat/hipchat-cli/master/hipchat_room_message > /usr/local/bin/hipchat_room_message && \
    chmod a+x /usr/local/bin/hipchat_room_message
