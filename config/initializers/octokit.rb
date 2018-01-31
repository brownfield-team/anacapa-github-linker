Octokit.configure do |c|
  c.login = ENV['MACHINE_USER_NAME']
  c.password = ENV['MACHINE_USER_KEY'] # NOTE: this can also just be the user's password rather than the oauth token
  Octokit.auto_paginate = true
end