require 'fileutils'

desc 'Bundle and run rspec on all gems inside this repo'
task 'specs:all'  do
  system(%(bundle)) # Bundle for the top level, e.g. install rubocop

  Dir.glob('*')
     .select { |f| File.directory?(f) && File.exist?("#{f}/#{f}.gemspec") }
     .each do |gem|
       puts "Bundling for #{gem}"
       system(%(cd #{gem} && bundle install)) or exit(-1)
       puts "+++ Testing #{gem}"
       system(%(cd #{gem} && rake spec)) or exit(-1)
       puts "Done with #{gem}"
     end
end
