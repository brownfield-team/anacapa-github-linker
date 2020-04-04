class GithubWebhooksController < ApplicationController
  include GithubWebhook::Processor
end