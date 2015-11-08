test:
	bundle exec rake spec

deploy: test
	@git checkout master
	@git pull
	@git push heroku
	@heroku run rake db:migrate
