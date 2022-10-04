# Load the Rails application.
require_relative "application"

override_variables = File.join(Rails.root, 'config', 'environments', 'override_variables.rb')
if File.exists?(override_variables)
    load(override_variables)
end

# Initialize the Rails application.
Rails.application.initialize!
