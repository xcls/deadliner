# Deadliner

[http://deadliner.r15.railsrumble.com/](http://deadliner.r15.railsrumble.com/)

[Google
Doc](https://docs.google.com/document/d/1A3BZiek0vwS231th9cLNzritOiCsGLL-wkR5Dzagwdk/edit)

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
