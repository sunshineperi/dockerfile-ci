FROM debian:wheezy

RUN apt-get update -y && apt-get install --no-install-recommends -y -q \
                         curl wget\
                         zip \
                         build-essential \
                         ca-certificates \
                         git mercurial bzr \
               && rm -rf /var/lib/apt/lists/*

ENV CF_VERSION 6.21.1
RUN curl -L -S "https://cli.run.pivotal.io/stable?release=linux64-binary&version=${CF_VERSION}" | tar xzf - -C /usr/local/bin
    
ENV GOVERSION 1.7
RUN mkdir /goroot && mkdir /gopath
RUN curl https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz \
           | tar xvzf - -C /goroot --strip-components=1

ENV GOPATH /gopath
ENV GOROOT /goroot
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH

RUN curl -L https://raw.githubusercontent.com/hipchat/hipchat-cli/master/hipchat_room_message > /usr/local/bin/hipchat_room_message && chmod a+x /usr/local/bin/hipchat_room_message
