def validate_ipa!
files = Dir['*.ipa']
@file ||= case files.length
		  when 0 then nil
		  when 1 then files.first
		  else
		     @file = choose "Select an .ipa", *files
		  end
end