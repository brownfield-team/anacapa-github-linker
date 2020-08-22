# Cypress

We are using the package <https://github.com/shakacode/cypress-on-rails>

## Usage

Start the rails server in test mode and start cypress

```shell
# start rails
RAILS_ENV=test bin/rake db:create db:schema:load
bin/rails server -e test -p 5017

# in separate window start cypress
yarn cypress open --project ./test
```
