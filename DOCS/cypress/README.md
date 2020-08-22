# Cypress

We are using the package <https://github.com/shakacode/cypress-on-rails>
# Terminal/Batch usage

Start the rails server in test mode and start cypress

```shell
# start rails
bin/rails server -e test -p 5017

# in separate window start cypress
yarn cypress run --project ./test
```

## Interactive Usage

Start the rails server in test mode and start cypress

```shell
# start rails
bin/rails server -e test -p 5017

# in separate window start cypress
yarn cypress open --project ./test
```


