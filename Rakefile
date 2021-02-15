desc 'Bundle and run rspec on all gems inside this repo'
task 'specs:all'  do
  system(%(bundle)) # Bundle for the top level, e.g. install rubocop

  Dir.glob('*')
     .select { |f| File.directory?(f) && File.exist?("#{f}/#{f}.gemspec") }
     .each do |gem|
       p "Testing #{gem}"
       system(%(cd #{gem} && bundle install && rake spec && cd ../))
       p "Done with #{gem}"
     end
end
