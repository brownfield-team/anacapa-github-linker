install ruby 2.6.5
if possible install rvm and do rvm install 2.6.5
install postgres
install yarn
clone the linker from github. cd into the dir and run gem install bundler and gem install pg
then run bundle install (remove gem pg line from the gem file) but uncomment it after
configure postgres conf file
set up github app and access tokens in the env file
generate tokens for GITHUB_WEBHOOK_SECRET and DEVISE_SECRET_KEY
generate slack tokens
do rake db:create
rake db:migrate
run rails s