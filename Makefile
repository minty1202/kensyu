build:
	docker-compose build

down:
	docker-compose down

up:
	rm -rf tmp/pids/*
	touch tmp/caching-dev.txt
	docker-compose up

setup:
	docker-compose run --rm app bundle exec rails db:drop db:create db:migrate

install:
	docker-compose run --rm app bundle install
	docker-compose run --rm app yarn install

init: build install setup
