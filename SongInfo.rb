class SongInfo

	attr_accessor:file
	attr_accessor:filename

	def initialize 
		@info = Array.new()
		@filename = ""
		@file = ""
	end

	################file########################
	def set_file()
		print "input file name:"
		#while(filename = gets.chop) do
		@filename = gets.chop
		if File.exist?(@filename) == false
			print @filename + " is not found.\n "
		else
			@file = open(@filename,"r")
			p @file
		end
	end

	def closefile()
		@file.close
	end	
	################INFORMATION#################
	def show_info ()
		#full #TITLE is 
		#["#TITLE:smooooch・∀・;\r\n"]
		@info = @file.grep(/#.*;/m)
		puts @info[0]
		puts @info[2]
		puts @info[16]
		puts @info.size

		#show level
		#sample
		#Begginer:    2:
		require "open3"
		out = Array.new()

		level = ["Beginner","Easy","Medium","Hard","Challenge"]
		level.size.times do |tmp|
			out, err, stat = Open3.capture3("grep -A 1 #{level[tmp]} sm")
			out_arr = out.split("\r\n")
			#print tmp

			out_arr.size.times do |i|
				out_arr[i].strip!
				#	print sprintf("%10s", out_arr[i]);
			end	
			#puts
			puts sprintf("%10s %5s",out_arr[0], out_arr[1])
		end
	end

end


