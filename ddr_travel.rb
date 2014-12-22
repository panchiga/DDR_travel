$info = Array.new()
$bpms = Hash.new()

#流れとして
#fileを読み込んでsetlineを読んでlinesに格納していく
#,を基準にboxとして扱い、linesを格納していく
#最期まで入れていき、levelsに格納して全難易度の入った箱を作る
#
#lines == box
#boxes == level
#levels == all levels 

class Mscore
	#attr_accessorこれをすることでこの名前の要素にアクセス出来る
	attr_accessor :lines 
	attr_accessor :boxes
	attr_accessor :levels
	attr_accessor :filename	
	attr_accessor :file

	attr_accessor :cont #l->l, l->d, l->u, l-> r,... 16 pattern
	attr_accessor :foot_levels# 足12とか

	def initialize 
		@lines = Array.new
		@boxes = Array.new
		#@levels = Array.new
		@levels = { "Beginner"=> [],"Easy"=> [], "Medium"=> [] ,"Hard"=> [],"Challenge"=> []}
		@filename = ""
		@file = ""

		@cont = Array.new(16, 0)
		@foot_levels = {"Beginner"=> 0,"Easy"=> 0, "Medium"=> 0 ,"Hard"=> 0,"Challenge"=> 0}
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

	def setlevel(key)
		@levels[key] = (@boxes.dup)
		@boxes.clear()
	end

	################READ FILE###################
	def readfile()
		info_i = 0
		mainflag = false
		dp_flag = 0
		print @file.find {|line| /TITLE/ =~ line}

		lev = ""

		@file.each do |line|
			if line.index(/double/)
				dp_flag = 1
			end
			if dp_flag == 0
				if line.index(/Beginner|Easy|Medium|Hard|Challenge/)
					lev = line.split(":")[0].split(" ").pop
				end
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
							setlevel(lev)
						end	
					end
				else
					#p line
					$info[info_i] = line.to_s.chop
					#puts "#{info_i}:#{$info[info_i]}"
					info_i += 1
				end
			end
		end
		set_bpm()
	end

	################file########################
	def set_file()
		#while(filename = gets.chop) do
		#@filename = gets.chop
		@filename = ARGV[0]

		if File.exist?(@filename) == false
			print @filename + " is not found.\n "
			#next
		else
			@file = open(@filename,"r")
			p "filename: #{Regexp.escape(@filename)}"
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

		require "open3"
		out = Array.new(5,"")


		level = ["Beginner","Easy","Medium","Hard","Challenge"]
		level.each do |tmp|

			out, err, stat = Open3.capture3("grep -A 1 #{tmp} #{Regexp.escape(@filename)}")
			out_arr = out.split("\r\n")

			#puts $info[0]

		#puts level[tmp]
			
			out_arr.size.times do |i|
				out_arr[i].strip!
				#	print sprintf("%10s", out_arr[i]);
			end	
			#puts
			puts sprintf("%10s %5s",out_arr[0], out_arr[1])
			@foot_levels[tmp] = out_arr[1]
		end
	end

	def set_bpm ()
		num = 0

		$info.size.times do |i|
			num = i if $info[i].index("BPM") != nil
		end

		changes = $info[num].split(";")[0].split(":")[1].split(",")
		changes.size.times do |i|
			$bpms.store(changes[i].split("=")[0].to_i ,changes[i].split("=")[1].to_f)
		end
	end

	def show_bpms 
		$bpms.size.times do |i|
			puts "#{$bpms.keys[i]}: #{$bpms[$bpms.keys[i]]}"
		end
	end

	def reload_bpm (bpm,now)
	 	if $bpms[now] != nil	
			bpm = $bpms[now]
		else
			bpm = bpm
		end
		return bpm
	end


	##########################このプログラムの中心##########################
	def travel(lev)
		tmp1 = 0
		tmp2 = 1
		bpm = $bpms[$bpms.keys[0]]

		#tmp2
		#tmp1
		#nawの順

		#移動距離
		travel = 0

		no_notes = 0
		no_box = 0

		now_mesure = 0.0
		bo_counter = 0

		tmp_bo_size = 4
		tmp_notes = 0
		# 計算をしてる 
		@levels[lev].each do |bo|	
			lin_counter = 0
			no_notes *= (bo.size.to_f / tmp_bo_size.to_f).to_i
			tmp_bo_size = bo.size if bo.size != 0
			
			bo.each do |lin|
				lin_counter = 1.0/(bo.size/4.0)
				now_mesure += lin_counter# + bo_counter * 4.0
				bpm = reload_bpm(bpm,now_mesure.to_i)
				#なにもないところか、ジャンプか1つのノーツかを判断
				if (lin.count("0") == 4) || (lin.count("3") > 0)
					no_notes += 1
					next
				elsif (lin.count("0") == 2 )
					jump = true
					jpan = calculate(0,0,no_notes+tmp_notes,no_box,bo.size,jump,bpm)
					travel += jpan
					#puts "#{jpan}: jump!"	

					tmp_notes = no_notes
					no_notes = 0
					no_box = 0
				elsif (lin.count("1") == 1)|| lin.count("2") == 1
					jump = false
					lin.size.times do |i|
						if(lin[i].to_i != 0 && lin[i].kind_of?(String) )
							stamp = calculate(tmp2, i, no_notes+tmp_notes, no_box, bo.size,jump,bpm)
							travel += stamp
							tmp2 = tmp1
							tmp1 = i
							#puts "#{stamp}: stamp!"

							break
						end
					end
					tmp_notes = no_notes
					no_notes = 0
					no_box = 0
				end
				if no_notes == bo.size
					no_notes = 0
					no_box += 1
				end
			end
		end
		travel_file = open("travel.csv","a")

		travel_file.print "#{@foot_levels[lev]},"
		travel_file.print "#{@filename.split("/").pop},"
		travel_file.print "#{travel}"
		travel_file.puts
		travel_file.close

		puts "travel: #{travel}"
	end


	#1歩ごとの体力消費を計算
	def calculate(before, after, no_notes, no_box, box_size,jump,bpm)#jump == true or false

		near = 0.40 #l->u, l->d,...
		over = 0.56 #l->r, u->d,...
		same = 0.30 #l->l, r->r,...
		jp = 0.6 #jump

		this = 0

		if jump == true 
			this = jp
		elsif before == after
			this = same
		elsif (before == 0 && after == 3)||(before == 3 && after == 0) || (before == 1 && after == 2) || (before == 2 &&after == 1)
			this = over
		else
			this = near
		end

		return (bpm * this * box_size)/(1+no_notes+4*no_box)

	end
end


##############################--MAIN--##########################
song = Mscore.new()

song.set_file()

song.readfile()

song.show_info()
#song.show_bpms()
#print "please iuput level: "
#level_num = gets.to_i
#song.travel(level_num)
song.travel("Hard")


song.closefile()
