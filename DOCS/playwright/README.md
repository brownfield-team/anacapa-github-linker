We are using [Playwright]() for end2end testing.

# Getting Started

Setup steps (first time)

1. `yarn install`
2. `npx playwright install`

# To run tests on localhost

Be sure that the test database is ready; if it isn't, see instructions below.

* To run the test suite and just see green checks or red x's, do:
 
  `yarn test:playwright`

* To run the test suite and actually see the browser, plus a control panel to
  control the execution of tests, use:

  `PWDEBUG=1 yarn test:playwright`

  This interface is also the means of "recording" test sequences into 
  code (existing tests are in JavaScript, so that would be the logical choice.)

  This generates the sequence of steps, but you will need to write your own 
  assertions.


# Preparing the test database

Create the test database if it doesn't exist:
* `RAILS_ENV=test bundle exec rake db:create` or 
* `RAILS_ENV=test rails db:create`

You may need to migrate the test database:
* `RAILS_ENV=test bundle exec rake db:migrate` or 
* `RAILS_ENV=test rails db:migrate`




# Playwright in CI/CD

See: `.github/workflows/ci-playwright.yml`

