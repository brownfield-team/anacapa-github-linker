We are using [Playwright]() for end2end testing.

# Getting Started

Setup steps (first time)

1. `yarn install`
2. `npx playwright install`

# To run tests on localhost

Be sure that the test database is ready; if it isn't, see instructions below.

Then do: `yarn test:playwright`


# Preparing the test database

Create the test database if it doesn't exist:
* `RAILS_ENV=test bundle exec rake db:create` or 
* `RAILS_ENV=test rails db:create`

You may need to migrate the test database:
* `RAILS_ENV=test bundle exec rake db:migrate` or 
* `RAILS_ENV=test rails db:migrate`


# Playwright in CI/CD

See: `.github/workflows/ci-playwright.yml`

