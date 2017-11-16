require 'plist'
require 'zip'
require 'zip/filesystem'
require 'validate_ipa'
require 'extract_zip'
require 'entitlements'
require 'profiles'

def write_plist_to_path(plist, path)
	File.write(path, plist)
end

command :compare do |c|
  c.syntax = 'howsigned compare [.ipa file] [.ipa file]'
  c.description = 'Prints diff of entitlements of specified .ipa files in plist format, nothing if entitlements are identical'
  c.action do |args, options|
	first_file = validate_ipa(args.pop)
	second_file = validate_ipa(args.pop)

	first_tempdir = ::File.new(Dir.mktmpdir)
	extract_zip(first_file, first_tempdir)

	second_tempdir = ::File.new(Dir.mktmpdir)
	extract_zip(second_file, second_tempdir)

	first_entitlements = get_entitlements(first_tempdir.path)
	second_entitlements = get_entitlements(second_tempdir.path)

	first_profiles = get_profiles(first_tempdir.path)
	second_profiles = get_profiles(second_tempdir.path)

	temp_plist_dir = ::File.new(Dir.mktmpdir).path
	write_plist_to_path(first_entitlements, "#{temp_plist_dir}/entitlements1.plist")
	write_plist_to_path(second_entitlements, "#{temp_plist_dir}/entitlements2.plist")
	write_plist_to_path(first_profiles, "#{temp_plist_dir}/profiles1.plist")
	write_plist_to_path(second_profiles, "#{temp_plist_dir}/profiles2.plist")

	entitlements_diff = `diff "#{temp_plist_dir}/entitlements1.plist" "#{temp_plist_dir}/entitlements2.plist"`
	profiles_diff = `diff "#{temp_plist_dir}/profiles1.plist" "#{temp_plist_dir}/profiles2.plist"`

	if (entitlements_diff.length > 0)
		puts entitlements_diff
	end

	if (profiles_diff.length > 0)
		puts profiles_diff
	end
  end
end
