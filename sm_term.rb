#1. smを読む
#2. 配列つくる
#→ 譜面データのはいる配列
#3. レベルを出す
#4. どのレベルで登録するか決める
#5. PLAY
#
#6. 0000を飛ばして1行ずつ読む
#7. 0を・、1を矢印、3を<VA>、その後そのパネルは|、2を<VA>で表現
#8. ノーツを予め登録した左足左下上右、右足左下上右のキーで踏む
#→ 同時は左下上右の順で入力
#→ フリーズを踏んでる最中にフリーズ踏んでる足を選んで踏んだらスイッチしたということで
#→ → 1拍未満ならセーフ
#9. 踏んだノーツに対応してLRを書く
#→  ・・↑・ だったら
#→  ・・L・みたいな
#
#これで一ファイル
#
#次にそのファイルを基に解析
require 'simple_color'

$color = SimpleColor.new

$info = Array.new()

class Musicsm
	#これをすることでこの名前の要素にアクセス出来る
	attr_accessor :lines 
	attr_accessor :boxes
	attr_accessor :levels
	attr_accessor :filename	
	attr_accessor :file

	attr_accessor :lf
	attr_accessor :df
	attr_accessor :uf
	attr_accessor :rf

	def initialize 
		@lines = Array.new
		@boxes = Array.new
		@levels = Array.new
		@filename = ""
		@file = ""

		@lf = false
		@df = false
		@uf = false
		@rf = false

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
		mainflag = false
		@file.each do |line|
			if (mainflag == false) and (line[0] == "/") 
				mainflag = true
			else
				if line.chop!.size == 4
					setline(line[0],line[1],line[2],line[3])
					#puts line
				end
				if line[0]==","
					#p @lines
					setbox()
					#p @boxes
				end
				if line[1] ==";"
					#p @boxes

					setlevel()
				end	
			end
		end
	end

	################INFORMATION#################
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
			out, err, stat = Open3.capture3("grep -A 1 #{level[tmp]} POSSESSION.sm")
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

		
	################file########################
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

	def play(level)
		i = 0
		compare_0 = Array.new(4,"0")
		@levels[level].each do |box|
			j = 0
			box.each do |line|
				if line == compare_0
					j += 1
					next
				else
					ch_color(j,box.size)
					transArrow(line[0],line[1],line[2],line[3])
				end
				$color.off
				j += 1
			end
			i+=1
			$color.echos(:white, "#{i}----------------")
		end
		
	end

	def ch_color(i, box_size)
		colors = Array.new(4)
		colors[0] = :red
		colors[1] = :blue
		colors[2] = :yellow
		colors[3] = :green

		quote = 0

		if (box_size % 4 == 0)
			quote = box_size/4
		end

		case i%quote
			when 0
				$color.ch_fg(:red)
			when quote/2
				$color.ch_fg(:blue)
			when quote/4, (quote/4)+(quote/2)
				$color.ch_fg(:yellow)
			else
				$color.ch_fg(:green)
		end

		#print "#{i} :"
	end

	def transArrow(l1, l2, l3, l4)

		left 	= "<"
		down 	= "V"
		up	 	= "A"
		right = ">"

		@lf = trance(left, l1, @lf)
		@df = trance(down, l2, @df)
		@uf = trance(up, l3, @uf)
		@rf = trance(right, l4, @rf)

		puts

	end	

	def trance (arrow, l, ff)

		freez = "|"
		dot = "-"
		
		if (l == "1" || l == "2")
			print sprintf("%4s", arrow)
			if(l == "2")
				ff = true
			end
		else
			if(ff == true )
				print sprintf("%4s", freez)
			else
				print sprintf("%4s", dot)
			end
		end

		if (l == "3")
			ff = false
		end

		return ff
	end

end


############--#MAIN#--################################

song = Musicsm.new()

song.set_file()
song.readfile()
song.show_info()


song.play(gets.to_i)


song.closefile()

