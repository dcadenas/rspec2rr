Gem::Specification.new do |s|
  s.name     = "rspec2rr"
  s.version  = "0.1.0"
  s.date     = "2008-11-6"
  s.summary  = "Helps converting from rspec doubles to rr doubles"
  s.email    = "dcadenas@gmail.com"
  s.homepage = "http://github.com/dcadenas/rspec2rr"
  s.description = "rspec2rr is a Ruby script that helps you in the migration process from rspec dobules ro rr trying to reduce your manual work"
  s.has_rdoc = false
  s.authors  = ["Daniel Cadenas"]
  s.files    = [ "Manifest.txt", 
		"README.txt", 
		"Rakefile", 
		"rspec2rr.gemspec", 
		"lib/rspec2rr.rb", 
		"bin/rspec2rr"]
  s.test_files = ["spec/unit/rspec2rr_spec.rb", 
      "spec/integration/rspec2rr_spec.rb"]
end
