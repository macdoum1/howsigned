require 'plist'
require 'zip'
require 'zip/filesystem'
require 'validate_ipa'
require 'extract_zip'

def get_profiles(path)
	profiles = Hash.new
	Dir.glob(path) do |file|
		profile = `security cms -D -i "#{file}" 2>&1`
		plist_profile = Plist::parse_xml(profile)
		app_id = plist_profile["AppIDName"]
		profiles[app_id] = plist_profile
	end

	return profiles.to_plist
end

command :profiles do |c|
  c.syntax = 'howsigned profiles [.ipa file]'
  c.description = 'Prints embedded profiles of specified .ipa in plist format'
  c.action do |args, options|
  	validate_ipa! unless @file = args.pop
	puts "Missing or unspecified .ipa file" and abort unless @file and ::File.exist?(@file)

	tempdir = ::File.new(Dir.mktmpdir)
	extract_zip(@file, tempdir)

	puts get_profiles("#{tempdir.path}/**/*.mobileprovision")
  end
end


