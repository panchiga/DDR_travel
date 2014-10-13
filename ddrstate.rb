def show_info (file,string)
	#puts string + file.grep(/#$string:/).to_s.split(":")[1].split(";")[0]
	puts file.grep(/\##{string}:/)
end



#-------------main----------------------------

print "input file name:"
#while(filename = gets.chop) do
filename = gets.chop
	if File.exist?(filename) == false
		print filename + " is not found.\n "
	#	next
	end
	file = open(filename,"r")

	#full #TITLE is 
	#["#TITLE:smooooch・∀・;\r\n"]
	#puts file.grep(/#TITLE:/).to_s.split(":")[1].split(";")[0]

	#puts file.grep(/#/)

	show_info(file,"TITLE")
	show_info(file,"ARTIST")
	show_info(file,"BPMS")

	file.each do |line|
	#	puts line.index("000")
	end


	file.close
#end #while

