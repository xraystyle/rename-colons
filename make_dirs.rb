#!/usr/bin/ruby -w

require 'pathname'

Dir.mkdir("testing_dir")

Dir.chdir("testing_dir")

@dirs = []

@dirs << Pathname.new(Dir.pwd)

@colon_count = 0
@dir_count = 0

trap ("INT") {

	if @colon_count > 0

		puts
		puts
		puts "#{@colon_count} directories with colons created."
		puts "#{@dir_count} total directories were created."

	end

	exit!

}


def make_subdirs(path)

	Dir.chdir(path)

	(0..10).each do |i|

		if Dir.glob("**/").count >= 5040

			@dirs.delete(path.parent) if @dirs.include?(path.parent)

			next

		end

		if rand(0..99) >= 75

			rand_dir = Pathname.new(Dir.pwd + "/" + rand(100..9999).to_s + ":" + "abcabc")
			@colon_count += 1

		else

			rand_dir = Pathname.new(Dir.pwd + "/" + rand(100..9999).to_s)

		end 
		

		puts "\t Making Dir #{rand_dir}"

		Dir.mkdir(rand_dir) unless Dir.exists?(rand_dir)

		@dir_count += 1

		@dirs << rand_dir

	end

	@dirs.delete(path) if @dirs.include?(path)
	
end

 # (1..2).each do |i|

	# puts "Loop #{i}."

@dirs.each do |d|

	make_subdirs(d)

end
	
# end