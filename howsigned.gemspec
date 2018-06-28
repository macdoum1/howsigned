Gem::Specification.new do |s|
  s.name        = 'howsigned'
  s.version     = '1.0.2'
  s.date        = '2018-06-28'
  s.description = "Utility to see how the contained binaries within an .ipa are signed"
  s.summary 	= "Has the ability to print entitlements or embedded profiles from an ipa as well as compare and verify signing"
  s.authors     = ["Michael MacDougall"]
  s.email       = 'mmacdougall@etsy.com'
  s.executables << 'howsigned'
  s.license     = 'MIT'
  s.homepage    = "https://github.com/macdoum1/howsigned"
  s.metadata = { "source_code_uri" => "https://github.com/macdoum1/howsigned" }
  s.files       = ['lib/entitlements.rb',
                   'lib/profiles.rb',
                   'lib/verify.rb',
                   'lib/compare.rb',
                   'lib/validate_ipa.rb',
                   'lib/extract_zip.rb',
                   'lib/contained_binaries_definition.rb']
  s.add_dependency "plist", "~> 3.1"
  s.add_dependency "rubyzip", "~> 1.1"
  s.add_dependency "commander", "~> 4.3"
end
