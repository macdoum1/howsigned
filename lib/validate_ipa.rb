def validate_ipa(file)
	puts "Missing or unspecified .ipa file" and abort unless file and ::File.exist?(file)
	return file
end