require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'
require 'echoe'

task :default => :test
 
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files += ["README.rdoc"]
  rd.rdoc_files += Dir.glob("lib/**/*.rb")
  rd.rdoc_dir = 'doc'
end
 
Rake::TestTask.new do |t|
  t.pattern = File.dirname(__FILE__) + "/test/*_tests.rb"
end
 
Echoe.new("hebruby") do |p|
  p.author = "Ron Evans"
  p.summary = "Hebruby is a Ruby library to convert julian dates to hebrew dates, and vice-versa."
  p.url = "http://deadprogrammersociety.com/"
  p.install_message = "*** Hebruby was installed ***"
  p.include_rakefile = true
end

