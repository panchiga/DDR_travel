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


class Musicsm < SongInfo

	attr_accessor:lines
	attr_accessor:lboxes
	attr_accessor:levels

	def initialize 
		@lines = Array.new
		@boxes = Array.new
		@levels = Array.new
		
		@lf = false
		@df = false
		@uf = false
		@rf = false

		@rl = "h"
		@rd = "t"
		@ru = "n"
		@rr = "s"
		@ll = "a"
		@ld = "o"
		@lu = "e"
		@lr = "u"
		#self.set_arrows()
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
	def setScore()
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

	def show_level(level)
		p @levels[level]
	end

	def play(level)
		out_file = open("#{@filename}_#{level}_play.sm","w")
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
				j += 1
				out_file.puts(push_arrow())
				$color.off
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

	def set_arrows ()

		puts "leftHand left"
		@ll = gets.chop
		puts "leftHand down"
		@ld = gets.chop
		puts "leftHand up"
		@lu = gets.chop
		puts "leftHand right"
		@lr = gets.chop
		
		puts "rightHand left"
		@rl = gets.chop
		puts "rightHand down"
		@rd = gets.chop
		puts "rightHand up"
		@ru = gets.chop
		puts "rightHand right"
		@rr = gets.chop
	end

	def push_arrow
		arrow = gets.chop
		str = file_arrow(arrow)
		
		return str
	end

	def file_arrow (str)
		stamp = "----"
		str.size.times do |i|
			case str[i]
			when @ll
				stamp[0] = "L"
			when @ld
				stamp[1] = "L"
			when @lu
				stamp[2] = "L"
			when @lr
				stamp[3] = "L"
			when @rl
				stamp[0] = "R"
			when @rd
				stamp[1] = "R"
			when @ru
				stamp[2] = "R"
			when @rr
				stamp[3] = "R"
			end
		end
		out_arrows(stamp)
		return stamp
	end

	def out_arrows(str)
		print "\e[1A"
		
		str.length.times do |i|
			print sprintf("%4s",str[i])
		end
		puts "          "
		STDOUT.flush
	end

end


############--#MAIN#--################################

song = Musicsm.new()

song.set_file()
#song.show_info()

song.setScore()
song.play(3)


song.closefile()

