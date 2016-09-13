# Heavily inspired by Shenzhen's `ipa info`
# https://github.com/nomad/shenzhen/blob/master/lib/shenzhen/commands/info.rb

require 'plist'
require 'zip'
require 'zip/filesystem'

def validate_ipa!
files = Dir['*.ipa']
@file ||= case files.length
		  when 0 then nil
		  when 1 then files.first
		  else
		     @file = choose "Select an .ipa", *files
		  end
end

command :entitlements do |c|
  c.syntax = 'howsigned entitlements [.ipa file]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.action do |args, options|
  	validate_ipa! unless @file = args.pop
	puts "Missing or unspecified .ipa file" and abort unless @file and ::File.exist?(@file)

	tempdir = ::File.new(Dir.mktmpdir)
	unzip = `unzip "#{@file}" -d "#{tempdir.path}"`

	entitlements_hash = Hash.new

	# .app
	Dir.glob("#{tempdir.path}/**/*.app") do |file|
		entitlements = `codesign -d --entitlements :- "#{file}" 2>&1`
		plist_entitlements = Plist::parse_xml(entitlements)
		application_identifier = plist_entitlements["application-identifier"]
		entitlements_hash[application_identifier] = plist_entitlements
	end

	# .appex
	Dir.glob("#{tempdir.path}/**/*.appex") do |file|
		entitlements = `codesign -d --entitlements :- "#{file}" 2>&1`
		plist_entitlements = Plist::parse_xml(entitlements)
		application_identifier = plist_entitlements["application-identifier"]
		entitlements_hash[application_identifier] = plist_entitlements
	end

	puts entitlements_hash.to_plist
  end
end


