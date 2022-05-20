# README


This is a rails application that allows for course management in conjunction with GitHub and GitHub organizations. It pairs classes with GitHub organizations and invites students to the GitHub organization when the students join the course.

React Storybooks: [https://brownfield-team.github.io/anacapa-github-linker](https://brownfield-team.github.io/anacapa-github-linker)

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
  2. Using the machine user visit [Developer Settings](https://github.com/settings/developers) under the user's Settings.  
    - Here you can create a new OAuth application (this one), and get the keys necessary for this application to interact with the GitHub API.
    - The application callback url will be `https://insert-your-heroku-app-link-here/users/auth/github/callback`
  

  
  ### Setting environment variables
  1. Using the __Client ID__ and the __Client Secret__ from the GitHub app dashboard, which will be added to the Heroku app's Config Vars as __OMNIAUTH\_PROVIDER\_KEY__ and __OMNIAUTH\_PROVIDER\_SECRET__ of the Heroku app (Settings under the Application Dashboard)
  2. Create a random string (16 characters is fine) and set it as the value of __DEVISE\_SECRET\_KEY__.
  3. Go to the machine user's GitHub _Settings_ -> _Developer Settings_ -> _Personal Access Tokens_, and then create a token with __repo__, __admin:org__, and __notifications__ permissions. The created key will be __MACHINE\_USER\_KEY__, and the machine user's username will be __MACHINE\_USER\_NAME__.
  4. __OMNIAUTH\_STRATEGY__ should be set as __github__ and __GIT\_PROVIDER\_URL__ will be __github.com__
  ### Creating the database on heroku
  1. Navigate to the _More_ button on the and select _Run console_.
  2. Run `rake db:migrate`.
  3. Try the app!

## How to use
  ### Admins
  - The very first user to log in will automatically be promoted to admin. Every other user afterwards be a regular user. Only admins have access to the Users  page. From there, an admin can promote other users to admins or instructors.
  - Admins can manage all courses and users
  - Instructors can create courses and only manage their own courses.

  ### How do instructors create a course
  1. Identify your course name and quarter (e.g. CMPSC16-S18)
  2. Identify the github organization associated with your course (e.g. ucsb-cs16-w18-mirza or ucsb-cs32-w18)
  3. Add the machine user that you used in the setup (e.g. phtcon for the UCSB-CS instance) as an owner of your organization. This gives the application the ability to add students to the organization.
  4. Login to the app and create your course. Be sure the course organization field EXACTLY matches the github organization name.
  - An instructor can promote any of the students in a course to a TA. A TA can create students in the course, import a roster via CSV, download the roster to a CSV, and update a student in the course. 
  - TAs cannot delete a student, promote other students to TAs, or modify the course itself in any way. 

  ___NOTE:Remember to go to "Member Privileges" and change "Repository Permission" for Organization Members to "None"___  

  ### Instructions for students
  Dear Student:  We will be using github.com in this course.   We have created an organization called ___(insert org name here___ on github.com where you can create repositories (repos) for your assignments in this course.   The advantage of creating private repos under that organization is that the course staff (your instructors, TAs and mentors) will be able to see your code and provide you with help, without you having to do anything special.

  To join this organization, you need to do three things.

  1. If you don't already have a github.com account, create one on the "free" plan.
  2. If you don't already have your ___@umail.ucsb.edu email address associated with your github.com account. go to "settings", add that email, and confirm that email address.
  3.  Visit https://ucsb-cs-github-linker.herokuapp.com, login with your github.com account, click "Home", find this course, and click the "join course button".   That will automatically send you an invitation to join the course organization.
  4.  Visit that invitation and accept it.

## Rulebook

## Configuration
  - /users/auth/github/callback is the omniauth callback path
  - TODO: fill out the documentation

## Getting Started on Localhost

You will need:
* Ruby installed; I suggest installing `rvm` from <https://rvm.io>
   * If working on windows, we strongly recommend using Windows Subsystem for Linux (WSL)
   * First step in installing `rvm` is usually installing `gpg2`.
      * For Mac, see: [README-MACOS.md](README-MACOS.md)
      * For WSL, try: `sudo apt install gnupg2`
   * Installing `rvm` may take a while (10-20 minutes)
* Postgres (an SQL database) needs to be installed:
   - For MacOS, I suggest: <https://postgresapp.com/> (latest stable version)
   - For WSL:
     ```
     sudo apt install postgresql
     sudo service postgresql start
     sudo su - postgres
     createuser --superuser $USER # where $USER is your username
     psql
     ```
     
     Then:
        * `\password $USER` is typed into the `psql console to set up your account
	* `\q` to exit `psql`
	* `exit` to exit the `postgres` user shell and go back to a regular user shell

     
* `rvm install ruby-2.6.3` (note that this Ruby version might be different by the time you read this)
* `gem install bundler`
* Clone the repo, and run `bundle install`
* Make sure that Postgres is running locally
   - You might need to do `createuser -s -r postgres` per this [StackOverflow post](https://stackoverflow.com/questions/7863770/rails-and-postgresql-role-postgres-does-not-exist)
* `bundle exec rake db:create`
* `bundle exec rake db:migrate`
* Do  `cp dotenv.example .env`
   * Note that `.env` is a file in the `.gitignore` because you will configure it with secrets
   * Therefore it SHOULD NOT be committed to github
   * Note that `.env` is a hidden file, so you'll need `ls -a` to see it in your directory.
* Edit `.env` with the appropriate values. For advice on "appropriate values", see the section ".env values" below.   Note that these are NOT shell environment variables, but rather variables
   that are read into the Rails environment by the [dotenv-rails](https://github.com/bkeepers/dotenv) gem.
* Finally, run `rails s` and the application should come up.

# `.env` values

The `dotenv.example` file contains example values and some information on the values
you shoudl put into your `.env`.  Here is a bit more information.


The following two values can typically be left as is.  Originally, we had intended that
the code would work for different strategies and different git providers.  For the time being
it is only known to work with these values.  However, these values to have to be provided.

```
GIT_PROVIDER_URL=github.com
OMNIAUTH_STRATEGY=github
```

The next two values require you to set up a Github OAuth application.  

To configure an OAuth App for Github:

1. This link should take you directly to the page to create a new OAuth App: <https://github.com/settings/applications/new>
   
   Or you can navigate to it this way:
      * Go to the Settings page for your own github account
      * Find the tab down the left column that says "Developer Settings"
      * Click the tab for `OAuth Apps`
      * Click the button `New OAuth App`

2.  You now have a form to fill in.

    * Application name: Fill in something like `anacapa-github-linker on localhost`
     
    * Homepage URL: Enter
       * `http://localhost:3000` or

       
    * Application Description is optional.  If you fill it in, users will see it when they are asked to authorize access to their GitHub account.
    
    * Authorization callback URL:
       * `http://localhost:3000/users/auth/github/callback
       
3.  Once you enter this information, you'll get a client id and a client secret.

    * The client id goes in the `OMNIAUTH_PROVIDER_KEY`
    * The client secret goes in the `OMNIAUTH_PROVIDER_SECRET`

Next we have the machine user name.

For the machine user name, for testing purposes, use your own github userid.

```
MACHINE_USER_NAME=<your machine user's name>
```

For the machine user key, go to your settings, under developer settings, under personal access tokens, i.e. <https://github.com/settings/tokens>

Create a personal access token with the following scopes:

```
admin:org, admin:org_hook, notifications, repo
```

Put the access token value in for the machine users key.  Note that you should treat that
value VERY carefully, as it is equivalent to a password to your github account.

Revoke it when you are finished testing the application.

The final value can be any string that you type. It is used a cryptographic "salt", so it just needs to be arbitrary.

```
DEVISE_SECRET_KEY=<a random alphunmeric string used by devise to salt its sessions>
```

# Operations

To create a full backup of the current database:

```
heroku pg:backups:capture --app ucsb-cs-github-linker
heroku pg:backups:download --app ucsb-cs-github-linker
```

This creates `latest.dump` in the current directory.  Then you need to have postgres installed locally so that you can use the `pg_restore` command to convert this to a text `.sql` file like this:

```
pg_restore -f latest.sql latest.dump 
```

To have staging pull in data from production, run the following command (with heroku cli configured):
 ```
heroku pg:backups:restore `heroku pg:backups:url --app ucsb-cs-github-linker` DATABASE_URL --app anacapa-github-linker-test --confirm anacapa-github-linker-test
```

# Testing

For end2end testing, see: [`DOCS/playwright/README.md`](DOCS/playwright/README.md)