## CYWAD demo

This is a demonstrating how to use [cywad](https://github.com/estin/cywad) and deploy to [Heroku](https://heroku.com).

[Live demo](https://cywad.herokuapp.com/) on [Heroku](https://heroku.com) free quota:
- Please be patient, it will take some time for the app to wake up
- scheduler would work only on running app (the default interval is 1 minute)

Based on [Zenika/alpine-chrome](https://github.com/Zenika/alpine-chrome).

In Dockerfile:
 - download and compile [cywad](https://github.com/estin/cywad) backend
 - download and compile [cywad-pwa](https://github.com/estin/cywad-pwa) frontend

Currently configured:
 - [config/crates.toml](config/crates.toml) get total of downloads and crates on [crates.io](https://crates.io)
 - [config/github-cywad.toml](config/github-cywad.toml) github stars/issues/PRs for [cywad](https://github.com/estin/cywad) backend

For local start
```bash
$ docker build -t cywad-demo .
$ docker run --rm -e PORT=8000 -p 8000:8000 -it cywad-demo
```

To run with your config
```bash
$ docker run --rm -e PORT=8000 -p 8000:8000 -v $(pwd)/config:/opt/cywad-config -it cywad-demo
```
