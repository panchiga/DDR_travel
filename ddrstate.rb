$info = Array.new()
=begin
0 #TITLE:smooooch・∀・;
1 #SUBTITLE:;
2 #ARTIST:kors k;
3 #TITLETRANSLIT:smooooch;
4 #SUBTITLETRANSLIT:;
5 #ARTISTTRANSLIT:;
6 #CREDIT:;
7 #BANNER:smooooch.png;
8 #BACKGROUND:smooooch-bg.png;
9 #LYRICSPATH:;
10 #CDTITLE:./CDTITLES/beatmaniaIIDX.png;
11 #MUSIC:smooooch.mp3;
12 #OFFSET:0.480;
13 #SAMPLESTART:22.560;
14 #SAMPLELENGTH:15.000;
15 #SELECTABLE:YES;
16 #DISPLAYBPM:177.000;
17 #BPMS:0.000=177.340,4.000=176.994,256.000=173.077,256.500=173.077,257.000=180.000,257.500=177.023;
18 #STOPS:256.000=0.167
;
19 #BGCHANGES:;
=end


def show_info (file)
	#puts string + ":" + file.grep(/#/).to_s.split(":")[1].split(";")[0]
	$info = file.grep(/#/)
	puts $info[0]
	puts $info[2]
	puts $info[16]
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

	show_info(file)

	file.each do |line|
	end


	file.close
#end #while

