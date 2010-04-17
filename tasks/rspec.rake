begin
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = %w(-fs --color)
  end
rescue LoadError => ex
  desc 'rspec rake task not available (rspec not installed)'
  task :spec do
    abort 'RSpec rake task is not available. Be sure to install rspec as a gem.'
  end
end
