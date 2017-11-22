# Deadliner

[http://deadliner.r15.railsrumble.com/](http://deadliner.r15.railsrumble.com/)

## Installation

First, copy `.env` to `.env.local` and add the credentials of your Github app.

```
bundle install
cp database.yml.example database.yml
brake db:create db:migrate
rails s
```
## Screenshot

![](/public/screenshot.png)
