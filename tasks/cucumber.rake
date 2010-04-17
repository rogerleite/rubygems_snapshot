begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "features --format pretty"
  end

  namespace :cucumber do
    Cucumber::Rake::Task.new(:wip) do |t|
      t.cucumber_opts = "features --format pretty -t @wip --wip"
    end
  end

rescue LoadError
  desc 'cucumber rake task not available (cucumber not installed)'
  task :cucumber do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem.'
  end
end

