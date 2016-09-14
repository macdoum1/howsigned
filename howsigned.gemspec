Gem::Specification.new do |s|
  s.name        = 'howsigned'
  s.version     = '0.0.4'
  s.date        = '2016-09-13'
  s.summary     = "Howsigned?"
  s.description = "Utility to see how the contained binaries within an .ipa are signed"
  s.authors     = ["Michael MacDougall"]
  s.email       = 'mmacdougall@etsy.com'
  s.executables << 'howsigned'
  s.license     = 'MIT'
  s.homepage    = "http://www.etsy.com"
  s.files       = ['lib/entitlements.rb',
                   'lib/profiles.rb',
                   'lib/verify.rb',
                   'lib/validate_ipa.rb',
                   'lib/extract_zip.rb']
  s.add_dependency "plist", "~> 3.1"
  s.add_dependency "rubyzip", "~> 1.1"
  s.add_dependency "commander", "~> 4.3"
end