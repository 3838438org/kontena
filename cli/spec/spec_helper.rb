# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
end

require 'stringio'
require 'clamp'
require 'ruby_dig'
require 'kontena_cli'
require 'webmock/rspec'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
  config.before(:each) do
    @_temp_home_dir = Dir.mktmpdir
    allow(Dir).to receive(:home).and_return(@_temp_home_dir)
    allow(ENV).to receive(:[]).with(anything).and_call_original
    allow(ENV).to receive(:[]).with('DEBUG').and_call_original
    Kontena::Cli::Config.reset_instance
  end

  # disable pastel colors for all specs, regardless of order
  config.before(:all) do
    Kontena.pastel.resolver.color.disable!
  end

  config.after(:each) do
    RSpec::Mocks.space.proxy_for(File).reset
    RSpec::Mocks.space.proxy_for(Kontena::Cli::Config).reset
    FileUtils.remove_entry @_temp_home_dir if @_temp_home_dir
  end

  config.around(:each) do |example|
    catch :exit_with_error do
      begin
        example.run
      rescue SystemExit
        puts "Got SystemExit: #{$!.message} - Exit code: #{$!.status}"
      end
    end
  end

  unless ENV["DEBUG"]
    config.before(:each) do
      $stdout = StringIO.new
      $stderr = StringIO.new
    end

    config.after(:each) do
      $stdout = STDOUT
      $stderr = STDERR
    end
  end
end

require_relative 'support/client_helpers'
require_relative 'support/requirements_helper'
require_relative 'support/fixtures_helpers'
require_relative 'support/output_helpers'
require_relative 'support/exit_with_error_helper'
