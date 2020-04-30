ApiPagination.configure do |config|
  config.paginator = :kaminari

  config.total_header = 'X-Total'

  config.per_page_header = 'X-Per-Page'

  config.page_header = 'X-Page'

  config.response_formats = [:json]

  config.page_param = :page

  # Optional: what parameter should be used to set the per page option
  config.per_page_param = :per_page

  # Optional: Include the total and last_page link header
  # By default, this is set to true
  # Note: When using kaminari, this prevents the count call to the database
  config.include_total = true
end
