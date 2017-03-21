FROM debian:jessie

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y -q \
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
        bzr && \
    apt-get dist-upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV JQ_VERSION 1.5
RUN curl -L -S "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" >/usr/sbin/jq

ENV CF_VERSION 6.25.0
RUN curl -L -S "https://cli.run.pivotal.io/stable?release=linux64-binary&version=${CF_VERSION}" | tar xzf - -C /usr/local/bin

ENV GOVERSION 1.7.5
ENV GOPATH /gopath
ENV GOROOT /goroot
RUN mkdir -p $GOROOT && mkdir -p $GOPATH
RUN curl https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN curl -L https://raw.githubusercontent.com/hipchat/hipchat-cli/master/hipchat_room_message > /usr/local/bin/hipchat_room_message && chmod a+x /usr/local/bin/hipchat_room_message

ENV RUBY_VERSION 2.3.3
#RUN curl -sSL https://get.rvm.io | bash -s stable
#RUN /bin/bash -l -c "rvm requirements && rvm install ${RUBY_VERSION} && rvm use --default ${RUBY_VERSION} && gem install bundler --no-ri --no-rdoc"
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    echo 'eval "$(~/.rbenv/bin/rbenv init -)"' >> ~/.bashrc && \
    ~/.rbenv/bin/rbenv install 2.3.3 && \
    ~/.rbenv/bin/rbenv global 2.3.3
