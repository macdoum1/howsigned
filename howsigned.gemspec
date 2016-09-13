Gem::Specification.new do |s|
  s.name        = 'howsigned'
  s.version     = '0.0.2'
  s.date        = '2016-09-13'
  s.summary     = "Howsigned?"
  s.description = "Utility to see how the contained binaries within an .ipa are signed"
  s.authors     = ["Michael MacDougall"]
  s.email       = 'mmacdougall@etsy.com'
  s.executables << 'howsigned'
  s.license     = 'MIT'
  s.add_dependency "plist", "~> 3.1.0"
  s.add_dependency "rubyzip", "~> 1.1"
end