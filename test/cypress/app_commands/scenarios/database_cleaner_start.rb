require 'database_cleaner/active_record'
DatabaseCleaner.strategy = :transaction
DatabaseCleaner.start # usually this is called in setup of a test
