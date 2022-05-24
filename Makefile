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

rspec:
	docker-compose run --rm app bundle exec rspec

routes:
	docker-compose run --rm app bundle exec rails routes

console:
	docker-compose run --rm app bundle exec rails console

lint:
		docker-compose run --rm app bundle exec rubocop

fix:
		docker-compose run --rm app bundle exec rubocop -a

init: build install setup
