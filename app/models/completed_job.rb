# CompletedJob is no longer an accurate name for this model as the table now stores in-progress jobs as well.
# It has not been renamed yet to avoid associated headaches.

# Adds distance_of_time_in_words method
require 'action_view'
include ActionView::Helpers::DateHelper

class CompletedJob < ApplicationRecord
  def time_elapsed
    return distance_of_time_in_words_to_now(created_at, include_seconds: true) if summary == "In progress"
    distance_of_time_in_words(created_at, updated_at, include_seconds: true)
  end

end
