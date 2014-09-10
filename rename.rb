#!/usr/bin/ruby -w

unless ARGV[0]

	puts "Needs a directory as a command line argument."
	exit!
	
end

Dir.chdir(ARGV[0])

# Pathmname class gives us access to the "parent" method which is crucial.
require 'pathname'


# Set up an empty array to hold directories/pathnames.
@dirs = []

# Counter to keep track of the number or renamed entries.
@renamed = 0


# Fill it with pathnames fromt the current directory.
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

			# puts "Appending #{e} to @dirs..."
			# gets

			@dirs << Pathname.new(File.expand_path(e))

		end

end








until @dirs.empty? do
	
	# Take a directory, look at it.
	@dirs.each do |f|

		# puts "Checking dir #{f}..."
		# puts f.class
		# gets

		if /.*:+.*/.match(f.to_s)

			# If it has colons, rename it.
			rename_colons(f)

			# Find all the entries one level below the dir we're working with,
			# unless it's a file, keeping in mind that it's been renamed already.
			get_subs(Pathname.new(File.expand_path(f.to_s.gsub(":", "-")))) if File.directory?(File.expand_path(f.to_s.gsub(":", "-")))

			# Remove the parent directory from @dirs if it's still there.
			# This is where the "parent" method from Pathname is crucial.
			@dirs.delete(f.parent) if @dirs.include?(f.parent)
			@dirs.delete(f) if @dirs.include?(f)

		else
			# do the same as above, except without the renaming.
			get_subs(f) if File.directory?(f)
			@dirs.delete(f.parent) if @dirs.include?(f.parent)
			@dirs.delete(f) if @dirs.include?(f)

		end

	end


end
puts
puts
puts
puts "#{@renamed} directories with colons renamed."

# Dir["*"].each do |file|

# 	if /.*:+.*/.match(file)
# 		rename_colons(file)
# 	end

# end











# files = []
# begin

# 	# Dir["**/*"].each {|f| File.rename(f, f.gsub(":", "-"))}
# 	Dir["*"].each do |file|

# 		if /.*:+.*/.match(file)

# 			File.rename(file, file.gsub(":", "-"))

# 		end

# 	end



# 	files = files.sort_by {|x| x.length}.reverse

# 	files.each { |e| puts e }
# 	# files.each {|f| File.rename f, f.gsub(":", "-")}

# rescue Exception => e

# 	puts "Error: #{e}"

# end