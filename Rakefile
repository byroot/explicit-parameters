require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :spec do
  task :all do
    %w(4.2 5.0).each do |rails_version|
      command = %W{
        BUNDLE_GEMFILE=gemfiles/Gemfile.rails-#{rails_version}
        rspec
      }.join(' ')
      puts command
      system(command)
    end
  end
end
