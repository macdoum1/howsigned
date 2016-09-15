require 'plist'
require 'zip'
require 'zip/filesystem'
require 'validate_ipa'
require 'extract_zip'
require 'contained_binaries_definition'

def verify_binaries(path)
	Dir.glob(path) do |file|
		codesign = `codesign --verify "#{file}" 2>&1`
		if (!codesign.to_s.empty?)
			puts codesign
		end
	end
end

command :verify do |c|
  c.syntax = 'howsigned verify [.ipa file]'
  c.description = 'Verifies the code signature of all binaries contained within the .ipa, will return nothing if signed correctly'
  c.action do |args, options|
	file = validate_ipa(args.pop)

	tempdir = ::File.new(Dir.mktmpdir)
	extract_zip(file, tempdir)

	entitlements_hash = Hash.new

	contained_binary_extensions().each { |extension|
		verify_binaries("#{tempdir.path}/**/*.#{extension}")
	}
  end
end


