# README

### Status
[![Build Status](https://travis-ci.org/project-anacapa/anacapa-github-linker.png)](https://travis-ci.org/project-anacapa/anacapa-github-linker)

## Deploying to Heroku
  ### Selecting version/branch on heroku from this repository
  1. Fork this repository to the GitHub user that's responsible for Heroku.
  2. Navigate to your apps dashboard on [Heroku](https://dashboard.heroku.com/apps) and create a new application.
  3. Select GitHub as the deployment method and then specify the forked repo, then hit deploy at the bottom.

  #### Hey it's not working...
  - Don't worry, there is still some other setup we need to do before it's up and running.

  ### Machine user and application key setup
  1. Create a new Github account. This account will act as the machine user for this application, and will be the user that handles interactions with the GitHub API that require verification (inviting to organizations, editting repos, etc.).
    - __NOTE:__ GitHub has a policy of limiting each human user to one machine user. Violating this rule violates their terms of service.
  2. Using either the machine user or another trusted GitHub account, visit [Developer Settings](https://github.com/settings/developers) under the user's Settings.  
    - Here you can create a new OAuth application (this one), and get the keys necessary for this application to interact with the GitHub API.
    - The application callback url will be http://insert-your-heroku-app-link-here/users/auth/github/callback 
  

  
  ### Setting environment variables
  1. Using the __Client ID__ and the __Client Secret__ from the GitHub app dashboard, which will be added to the Heroku app's Config Vars as __OMNIAUTH\_PROVIDER\_KEY__ and __OMNIAUTH\_PROVIDER\_SECRET__ of the Heroku app (Settings under the Application Dashboard)
  2. Create a random string (16 characters is fine) and set it as the value of __DEVISE\_SECRET\_KEY__.
  3. Go to the machine user's GitHub _Settings_ -> _Developer Settings_ -> _Personal Access Tokens_, and then create a token with __repo__, __admin:org__, and __notifications__ permissions. The created key will be __MACHINE\_USER\_KEY__, and the machine user's username will be __MACHINE\_USER\_NAME__.
  4. __OMNIAUTH\_STRATEGY__ should be set as __github__ and __GIT\_PROVIDER\_URL__ will be __github.com__
  ### Creating the database on heroku
  1. Navigate to the _More_ button on the and select _Run console_.
  2. Run `rake db:migrate`.
  3. Try the app!

## Rulebook

## Configuration
  - /users/auth/github/callback is the omniauth callback path
  - TODO: fill out the documentation
