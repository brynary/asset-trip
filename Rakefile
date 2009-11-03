require "spec/rake/spectask"

Spec::Rake::SpecTask.new do |t|
  t.warning = true
end

task :default => :spec

desc 'Removes trailing whitespace'
task :whitespace do
  sh %{find . -name '*.rb' -exec sed -i '' 's/ *$//g' {} \\;}
end