
#出力色を変えるライブラリ
require 'simple_color'
$color = SimpleColor.new
$pre_color = SimpleColor.new

require './SongInfo.rb'
require './Color_set.rb'

#.smファイルのヘッダーとファイル
#.smの譜面部分を扱うクラス
#でかい

class Musicsm < SongInfo

	attr_accessor:lines
	attr_accessor:lboxes
	attr_accessor:levels
	attr_accessor:fg_color

	attr_accessor:color_set

	def initialize 
		@lines = Array.new
		@boxes = Array.new
		@levels = Array.new

		@color_set = Color_set.new

		@fg_color = :red
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

	#選んだlevelに対応した譜面を出力
	#足でどう踏むかを登録
	#out_fileに踏んだ履歴を書き込む
	#
	##失敗した際のリカバリがないのが問題
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
					@color_set.ch_color(j,box.size)
					@color_set.transArrow(line[0],line[1],line[2],line[3])
				end
				j += 1
				out_file.puts(@color_set.push_arrow(@fg_color))
				$color.off
			end
			i+=1
			$color.echos(:white, "#{i}----------------")
		end
		
	end

end


