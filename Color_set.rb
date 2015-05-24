
class Color_set 
	def initialize
	
		#フリーズアローのフラッグ
		@lf = false
		@df = false
		@uf = false
		@rf = false

	
		#Dvorak仕様のホームポジション
		@rl = "h"
		@rd = "t"
		@ru = "n"
		@rr = "s"
		@ll = "a"
		@ld = "o"
		@lu = "e"
		@lr = "u"

	end
	#出力の際の色を変える
	#NOTEスキン仕様
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
				res_col = :red
			when quote/2
				$color.ch_fg(:blue)
				res_col = :blue
			when quote/4, (quote/4)+(quote/2)
				$color.ch_fg(:yellow)
				res_col = :yellow
			else
				$color.ch_fg(:green)
				res_col = :green
		end
		@fg_color = res_col
		return res_col
		#print "#{i} :"
	end

	#数字で与えられる行を矢印に置き換える
	#0010 から --A- のように
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

	#tranceArrowの友達
	#LDURを1文字ずつ見る
	#arrowはLDUR
	#lは普通の矢印、フリーズ、フリーズ終わり何かを見分ける
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

	#世の中にはDvorakじゃない人もいるのでその人たち向け
	#優しい
	def set_arrows 

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

	#どんな風に踏むか入力して翻訳して返す
	#--A- n だったら --L-みたいに
	#ここでnは左手のUpに対応
	def push_arrow(fg_color)
		arrow = gets.chop
		str = file_arrow(arrow,fg_color)

		
		return str
	end

	#push_arrowの友達
	#どのキーがおされたかを見て再出力する関数
	#直接的には翻訳を担当
	#同時押し対応
	def file_arrow (str,fg_color)
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
		out_arrows(stamp,fg_color)
		return stamp
	end

	#file_arrowと友達
	#書きなおして再出力の部分を担当
	def out_arrows(str,fg_color)
		print "\e[1A"
		
		str.length.times do |i|
			if (str[i] == "L")
				$color.ch_bg(:red)
			elsif (str[i] == "R")
				$color.ch_bg(:blue)
			end
			print sprintf("%4s",str[i])

			$color.off()
			$color.ch_fg(fg_color)

		end
		puts "          "
		STDOUT.flush
	end

end
