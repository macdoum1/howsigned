# Heavily inspired by Shenzhen's `ipa info`
# https://github.com/nomad/shenzhen/blob/master/lib/shenzhen/commands/info.rb

require 'plist'
require 'zip'
require 'zip/filesystem'
require 'validate_ipa'
require 'extract_zip'
require 'contained_binaries_definition'

def append_entitlements(path, entitlements_hash)
	index = 0
	Dir.glob(path) do |file|
		entitlements = `codesign -d --entitlements :- "#{file}" 2>&1`
		plist_entitlements = Plist::parse_xml(entitlements)
		if (plist_entitlements)
			application_identifier = plist_entitlements["application-identifier"] ? plist_entitlements["application-identifier"] : index.to_s
			entitlements_hash[application_identifier] = plist_entitlements
			index = index + 1
		end
	end
end

def get_entitlements(tempdir_path)
	entitlements_hash = Hash.new

	contained_binary_extensions().each { |extension|
		append_entitlements("#{tempdir_path}/**/*.#{extension}", entitlements_hash)
	}

	if (entitlements_hash.length == 0)
		abort "No entitlements found on contained binaries"
	end

	return entitlements_hash.to_plist
end

command :entitlements do |c|
  c.syntax = 'howsigned entitlements [.ipa file]'
  c.description = 'Prints entitlements of specified .ipa in plist format'
  c.action do |args, options|
	file = validate_ipa(args.pop)

	tempdir = ::File.new(Dir.mktmpdir)
	extract_zip(file, tempdir)

	puts get_entitlements(tempdir.path)
  end
end


