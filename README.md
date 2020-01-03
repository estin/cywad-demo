## CYWAD demo

This is demo how to use and deploy [CYWAD](https://github.com/estin/cywad) to [Heroku](https://heroku.com)

[Live demo](http://cywad.herokuapp.com/) on [Heroku](https://heroku.com) free quota:
- please be patient the app must wake up
- scheduler would works only on running app

Based [Zenika/alpine-chrome](https://github.com/Zenika/alpine-chrome).

In Dockerfile:
 - download and compile [CYWAD](https://github.com/estin/cywad) backend
 - download and compile [CYWAD-PWA](https://github.com/estin/cywad-pwa) frontend

For local start
```bash
$ docker build -t cywad-demo .
$ docker run --rm -e PORT=8000 -p 8000:8000 -it cywad-demo
```

To run with yours config
```bash
$ docker run --rm -e PORT=8000 -p 8000:8000 -v $(pwd)/config:/opt/cywad-config -it cywad-demo
```
