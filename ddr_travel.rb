$info = Array.new()
$bpms = Array.new()
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
#最期まで入れていき、levelsに格納して全難易度の入った箱を作る
#
#lines == box
#boxes == level
#levels == all levels 
class Mscore
	#これをすることでこの名前の要素にアクセス出来る
	attr_accessor :lines 
	attr_accessor :boxes
	attr_accessor :levels
	attr_accessor :filename	
	attr_accessor :file

	attr_accessor :cont #l->l, l->d, l->u, l-> r,... 16 pattern

	def initialize 
		@lines = Array.new
		@boxes = Array.new
		@levels = Array.new
		@filename = ""
		@file = ""
		
		@cont = Array.new(16, 0)
	end
	################MUSIC SCORE#################
	#first, dance score in file to arrays
	def setline(l1,l2,l3,l4)
		line = [l1,l2,l3,l4]
		@lines.push(line)
	end

	def setbox()
		#p @lines
		@boxes.push(@lines.dup)
		
		@lines.clear()
	end

	def setlevel()
		@levels.push(@boxes.dup)
		@boxes.clear()
	end

	################READ FILE###################
	def readfile()
		info_i = 0
		mainflag = false
		print @file.find {|line| /TITLE/ =~ line}
		@file.each do |line|
			if line.index("#") == nil

				if (mainflag == false) and (line[0] == "/") 
					mainflag = true 
				else
					if line.chop!.size == 4
						setline(line[0],line[1],line[2],line[3])
						#puts line
					end
					if line.index(",") != nil
						#p @lines
						setbox()
						#p @boxes
					end
					if line.index(";") != nil 
						#p @boxes
						setlevel()
					end	
				end
			else
				#p line
				$info[info_i] = line.to_s.chop
				puts "#{info_i}:#{$info[info_i]}"
				info_i += 1
			end
		end
		set_bpm()
	end

	################file########################
	def set_file()
		print "input file name:"
		#while(filename = gets.chop) do
		#@filename = gets.chop
		@filename = ARGV[0]
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
	################INFORMATION#################
	def show_info ()
		#full #TITLE is 
		#["#TITLE:smooooch・∀・;\r\n"]
		#$info = @file.grep(/#.*;/m)
		
		
		#$info = 
		#puts $info[0]
		#puts $info[2]
		#puts $info[16]
		#puts $info.size

		#show level
		#sample
		#Begginer:    2:
		#
		require "open3"
		out = Array.new()
		

		level = ["Beginner","Easy","Medium","Hard","Challenge"]
		level.size.times do |tmp|
			out, err, stat = Open3.capture3("grep -A 1 #{level[tmp]} #{ARGV[0]}")
			out_arr = out.split("\r\n")
			
			#puts $info[0]

			out_arr.size.times do |i|
				out_arr[i].strip!
				#	print sprintf("%10s", out_arr[i]);
			end	
			#puts
			puts sprintf("%10s %5s",out_arr[0], out_arr[1])
		end
	end

	def set_bpm ()
		changes = $info[16].split(";")[0].split(":")[1].split(",")
		changes.size.times do |i|
			$bpms[i] = (changes[i].split("=")[1]).to_f
			puts $bpms[i]
		end
	end

	#同時が考慮されてない
	def count(lev)
		tmp = 0
		#移動距離
		
		no_notes = 0

		@levels[lev].each do |bo|	
			#puts "box.size: #{bo.size}"
			bo.each do |lin|
				#p lin
				(4 - lin.count(0)).times do	
					lin.size.times do |i|
						if(lin[i].to_i != 0 && lin[i].kind_of?(String) )
						tmp = tmp*4 + i.to_i
							@cont[tmp] += 1
							tmp = i
							calculate(lin[i],tmp,no_notes)
						end
					end
					no_notes = 0
				end
			no_notes += 1
			end
		end
		
	end

	def calculate(before, after,no_notes)
		
		near = 0.40 #l->u, l->d,...
		over = 0.56 #l->r, u->d,...
		same = 0.30 #l->l, r->r,...
	
		this = 0

		if before == after
			this = same
		elsif (before == 0 && after == 3)||(before == 3 && after == 0) || (before == 1 && after == 2) || (before == 2 &&after == 1)
			this = over
		else
			this = near
		end
		

	end


end

class Human
	attr_accessor :l_leg
	attr_accessor :r_leg

	def initialize()
		#left foot, right foot
		#[0,1,2,3] 
		#use queue
		#example, right->left
		#then, left->right 
		@l_leg = 0
		@r_leg = 3
	end
 
	def dancing()
	end


end



#-----------------------main----------------------------
song = Mscore.new()
human = Human.new()
song.set_file()

#song.show_info()
song.readfile()

song.show_info()

#print "please iuput level: "
#level_num = gets.to_i
#song.count(level_num)
song.count(4)

song.closefile()
#end #while
