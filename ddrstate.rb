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


#流れとして
#fileを読み込んでsetlineを読んでlinesに格納していく
#,を基準にboxとして扱い、linesを格納していく
#最期まで入れていく
#
class Mscore
	#これをすることでこの名前の要素にアクセス出来る
	attr_accessor :lines 
	attr_accessor :box
	attr_accessor :filename	
	attr_accessor :file

	def initialize 
		@lines = Array.new()
		@box = Array.new()
		@filename = ""
		@file = ""
	end

	def setlines(l1,l2,l3,l4)
		line = [l1,l2,l3,l4]
		@lines.push(line)
	end

	def setbox()
		@box.push(@lines)
		@box.push(@lines)
		
	end

	def show_info ()

		#full #TITLE is 
		#["#TITLE:smooooch・∀・;\r\n"]
		$info = @file.grep(/#.*;/m)
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
			out, err, stat = Open3.capture3("grep -A 1 -n #{level[tmp]} sm")
			out_arr = out.split("\r\n")
			print tmp

			out_arr.size.times do |i|
				out_arr[i].strip!
				#	print sprintf("%10s", out_arr[i]);
			end	
			#puts
			puts sprintf("%10s %5s",out_arr[0], out_arr[1])
		end

	end

	def set_file()

		print "input file name:"
		#while(filename = gets.chop) do
		@filename = gets.chop
		if File.exist?(@filename) == false
			print @filename + " is not found.\n "
			#next
		else

			@file = open(@filename,"r")
			
			#てすとかな
			#@file.each do |line|
			#	puts line
			#end
		end
	end

	def closefile()
		@file.close
	end

end


#-----------------------main----------------------------
song = Mscore.new()
song.set_file()
song.show_info()

song.closefile()
#end #while

