require 'plist'
require 'zip'
require 'zip/filesystem'
require 'validate_ipa'
require 'extract_zip'

def verify_binaries(path)
	Dir.glob(path) do |file|
		codesign = `codesign --verify "#{file}" 2>&1`
		if(!codesign.to_s.empty?)
			puts codesign
		end
	end
end

command :verify do |c|
  c.syntax = 'howsigned verify [.ipa file]'
  c.description = 'Verifies the code signature of all binaries contained within the .ipa, will return nothing if signed correctly'
  c.action do |args, options|
  	validate_ipa! unless @file = args.pop
	puts "Missing or unspecified .ipa file" and abort unless @file and ::File.exist?(@file)

	tempdir = ::File.new(Dir.mktmpdir)
	extract_zip(@file, tempdir)

	entitlements_hash = Hash.new

	app_codesign = verify_binaries("#{tempdir.path}/**/*.app")
	if(!app_codesign.to_s.empty?)
		puts app_codesign
	end

	appex_codesign = verify_binaries("#{tempdir.path}/**/*.appex")
	if(!appex_codesign.to_s.empty?)
		puts appex_codesign
	end
  end
end


