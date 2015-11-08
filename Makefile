test:
	bundle exec rake spec

deploy: test
	@git checkout master
	@git push heroku
