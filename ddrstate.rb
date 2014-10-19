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
20-29 #NOTES:;
=end
def show_info (file)
	
	#full #TITLE is 
	#["#TITLE:smooooch・∀・;\r\n"]
	$info = file.grep(/#.*;/m)
	puts $info[0]
	puts $info[2]
	puts $info[16]
	puts $info.size

	#show level
	#sample
	#Begginer:    2:
	require "open3"
	out = Array.new()

	level = ["Beginner","Easy","Medium","Hard","Challenge"]
	level.size.times do |tmp|
		out, err, stat = Open3.capture3("grep -A 1 #{level[tmp]} sm")
		out_arr = out.split("\r\n")
		
		out_arr.size.times do |i|
			out_arr[i].strip!
			print sprintf("%10s", out_arr[i]);
		end	
		puts
		#puts sprintf("%10s %5s",out_arr[0], out_arr[1])
	end


end

#object name is basic,difficult,hard...
class Song
	def initialise(difficult,start_line,end_line)
		
	end

	def calc_damage 
		
	end
end


#-----------------------main----------------------------

print "input file name:"
#while(filename = gets.chop) do
filename = gets.chop
if File.exist?(filename) == false
	print filename + " is not found.\n "
	#next
end
	
file = open(filename,"r")
show_info(file)

file.each do |line|
	puts line
end


file.close
#end #while

