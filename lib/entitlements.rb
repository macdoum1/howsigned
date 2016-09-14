# Heavily inspired by Shenzhen's `ipa info`
# https://github.com/nomad/shenzhen/blob/master/lib/shenzhen/commands/info.rb

require 'plist'
require 'zip'
require 'zip/filesystem'
require 'validate_ipa'
require 'extract_zip'
require 'contained_binaries_definition'

def append_entitlements(path, entitlements_hash)
	Dir.glob(path) do |file|
		entitlements = `codesign -d --entitlements :- "#{file}" 2>&1`
		plist_entitlements = Plist::parse_xml(entitlements)
		application_identifier = plist_entitlements["application-identifier"]
		entitlements_hash[application_identifier] = plist_entitlements
	end
end

command :entitlements do |c|
  c.syntax = 'howsigned entitlements [.ipa file]'
  c.description = 'Prints entitlements of specified .ipa in plist format'
  c.action do |args, options|
  	validate_ipa! unless @file = args.pop
	puts "Missing or unspecified .ipa file" and abort unless @file and ::File.exist?(@file)

	tempdir = ::File.new(Dir.mktmpdir)
	extract_zip(@file, tempdir)

	entitlements_hash = Hash.new

	contained_binary_extensions().each { |extension|
		append_entitlements("#{tempdir.path}/**/*.#{extension}", entitlements_hash)
	}

	if (entitlements_hash.length == 0)
		abort "No entitlements found on contained binaries"
	end

	puts entitlements_hash.to_plist
  end
end


