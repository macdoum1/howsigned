require 'plist'
require 'zip'
require 'zip/filesystem'
require 'validate_ipa'
require 'extract_zip'

def get_profiles(tempdir_path, only_expiration)
	path = "#{tempdir_path}/**/*.mobileprovision"
	profiles = Hash.new
	index = 0
	Dir.glob(path) do |file|
		profile = `security cms -D -i "#{file}" 2>&1`
		plist_profile = Plist::parse_xml(profile)
		if plist_profile
			app_id = plist_profile["AppIDName"] ? plist_profile["AppIDName"] : index.to_s
			if only_expiration
				profiles[app_id] = plist_profile["ExpirationDate"]
			else
				profiles[app_id] = plist_profile
			end
			index = index + 1
		end
	end

	if (profiles.length == 0)
		abort "No embedded provisioning profiles found"
	end
	return profiles.to_plist
end

command :profiles do |c|
  c.syntax = 'howsigned profiles [.ipa file]'
  c.description = 'Prints embedded profiles of specified .ipa in plist format'
  c.option '--expiration', "When specified, will print only the expiration dates of embedded profiles"
  c.action do |args, options|
	file = validate_ipa(args.pop)
	only_expiration = options.expiration || false

	tempdir = ::File.new(Dir.mktmpdir)
	extract_zip(file, tempdir)

	puts get_profiles(tempdir.path, only_expiration)
  end
end


