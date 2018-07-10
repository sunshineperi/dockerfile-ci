Dockerfile-ci
====

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][LICENSE]
[![Docker Pulls](https://img.shields.io/docker/pulls/rakutentech/ci.svg?style=flat-square)][dockerhub]

[LICENSE]: https://github.com/rakutentech/dockerfile-ci/blob/master/LICENCE
[dockerhub]: https://hub.docker.com/r/rakutentech/ci/

Dockerfile for the RPaaS CI pipelines.

## Supported tags

See [`rakutentech/ci`][dockerhub] for a list of automatic builds.
We currently build the tip of `master` and all tags. The corresponding docker 
hub tags are named as each git tag, while the `master` branch is called `latest`).

For stability we recommend to use tagged versions in CI pipelines: avoid using 
untagged builds or `#latest`.

## Authors

[Taichi Nakashima](https://github.com/tcnksm)
[Carlo Alberto Ferraris](https://github.com/cafxx)
