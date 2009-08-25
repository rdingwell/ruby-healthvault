Gem::Specification.new do |s|
  s.name = 'ruby-healthvault'
  s.version = '0.0.2'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'Connect your Ruby code to the Microsoft HealthVault'
  s.description = s.summary
  s.homepage = 'http://rubyhealthvault.rubyforge.org/'
  s.rubyforge_project = 'rubyhealthvault'
  s.authors = ['Danny Coates','Rob Dingwell']
  s.email = 'dcoates@podfitness.com'
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end