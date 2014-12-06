#!/usr/bin/ruby -w

unless ARGV[0]

	puts "Needs a directory as a command line argument."
	exit!
	
end

Dir.chdir(ARGV[0])

# pathnames make it easier to manage paths,
# with clear methods to access their attributes.
require 'pathname'

# Set up an empty array to hold directories/pathnames.
@dirs = []

# Counter to keep track of the number of renamed entries.
@renamed = 0


# Fill it with pathnames from the given directory.
Dir['*'].each do |f|

	@dirs << Pathname.new(File.expand_path(f))

end



# Method that renames a path with colons to the same path, but replacing
# colons with hyphens.
def rename_colons(path)

	File.rename(File.expand_path(path), File.expand_path(path.to_s.gsub(":", "-")))
	@renamed += 1

end


# Get all subdirectories of a directory, append them to @dirs.
# This avoids the need for a recursive method to dig through directories.
def get_subs(path)

		path.children.each do |e|

			next if e.to_s == "."
			next if e.to_s == ".."
			next if /.*\._.*/.match e.to_s

			@dirs << Pathname.new(File.expand_path(e))

		end

end

puts "Working..."

until @dirs.empty? do
	
	# Take a directory, look at it.
	@dirs.each do |f|

		# system 'clear'
		# puts "Parsing #{f}..."

		if /.*:+.*/.match(f.to_s)

			# If it has colons, rename it.
			rename_colons(f)

			# Find all the entries one level below the dir we're working with,
			# unless it's a file, keeping in mind that it's been renamed already.
			# Make sure that everything is a Pathname instance instead of a string.
			get_subs(Pathname.new(File.expand_path(f.to_s.gsub(":", "-")))) if File.directory?(File.expand_path(f.to_s.gsub(":", "-")))

			# Remove the entry from the @dirs array
			
			# .delete returns nil if 'f' isn't in the array. This
			# substantially increases the speed of the script, as 
			# opposed to checking if it's there via @dirs.include?(f) 
			# first. .include? requires a brute-force check against 
			# every other item in the array.
			@dirs.delete(f) 
			

		else
			# do the same as above, except without the renaming.
			get_subs(f) if File.directory?(f)

			
			@dirs.delete(f) 
			
		end

	end


end
puts
puts
puts
puts "#{@renamed} directories with colons renamed."

exit 0