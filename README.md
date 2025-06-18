# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

*

run locally

** Build **

```bash
$ docker build -t rails-dev -f Dockerfile-dev .
```

** Run **

```bash
$ docker run -it \
  -p 3000:3000 \
  -v "$(pwd)":/rails \
  rails-dev bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"
```
