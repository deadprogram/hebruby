Gem::Specification.new do |s|
  s.name = %q{Hebruby}
  s.version = "1.2.2"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Ron Evans"]
  s.autorequire = %q{hebruby}
  s.cert_chain = nil
  s.date = %q{2006-11-25}
  s.email = %q{ron dot evans at gmail dot com}
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "lib/hebruby.rb", "test/hebruby_tests.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://www.deadprogrammersociety.com}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Hebruby is a Ruby library to convert julian dates to hebrew dates, and vice-versa.}
  s.test_files = ["test/hebruby_tests.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if current_version >= 3 then
    else
    end
  else
  end
end
