desc 'Bundle and run rspec on all gems inside this repo'
task 'specs:all'  do
  system(%(bundle)) # Bundle for the top level, e.g. install rubocop

  Dir.glob('*')
     .select { |f| File.directory?(f) && File.exist?("#{f}/#{f}.gemspec") }
     .each do |gem|
       puts "Bundling for #{gem}"
       system(%(cd #{gem} && bundle install))
       puts "+++ Testing #{gem}"
       system(%(cd #{gem} && rake spec))
       puts "Done with #{gem}"
     end
end
