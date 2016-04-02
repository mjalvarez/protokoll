require 'database_cleaner'
DatabaseCleaner.strategy = :transaction

class Minitest::Spec
  around do |tests|
    puts tests.inspect
    DatabaseCleaner.cleaning(&tests)
  end
end
