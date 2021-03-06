require "bundler/setup"
require "sqlite3"
require "active_record"
require "active_record/setops"
require "gen/test"
require "contracts/gen"

C = Contracts

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
