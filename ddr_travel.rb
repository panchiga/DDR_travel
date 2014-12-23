#流れとして
#fileを読み込んでsetlineを読んでlinesに格納していく
#,を基準にboxとして扱い、linesを格納していく
#最期まで入れていき、levelsに格納して全難易度の入った箱を作る
#

#levels <- boxes <- linesの順番 
$info = Array.new()
$bpms = Hash.new()

class Mscore
	#attr_accessorこれをすることでこの名前の要素にアクセス出来る
	attr_accessor :lines 
	attr_accessor :boxes
	attr_accessor :levels
	attr_accessor :filename	
	attr_accessor :file
	attr_accessor :foot_levels# 足12とか

	def initialize 
		@lines = Array.new
		@boxes = Array.new
		@levels = { "Beginner"=> [],"Easy"=> [], "Medium"=> [] ,"Hard"=> [],"Challenge"=> []}
		@filename = ""
		@file = ""
		@foot_levels = {"Beginner"=> 0,"Easy"=> 0, "Medium"=> 0 ,"Hard"=> 0,"Challenge"=> 0}
	end

	################MUSIC SCORE#################
	#first, dance score in file to arrays
	def setline(l1,l2,l3,l4)
		line = [l1,l2,l3,l4]
		@lines.push(line)
	end

	def setbox()
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
		lev = ""
		lev_flag = false

		@file.each do |line|
			#level入れてる
			if lev_flag == true
				line.strip!
				line.chop!
				@foot_levels[lev] = line.to_i
				lev_flag = false
				next
			end
			if line.index(/double/)
				dp_flag = 1
			end
			if dp_flag == 0
				if line.index(/Beginner|Easy|Medium|Hard|Challenge/)
					lev = line.split(":")[0].split(" ").pop
					lev_flag = true
				end
				if line.index("#") == nil

					if (mainflag == false) and (line[0] == "/") 
						mainflag = true 
					else
						#配列に譜面データを突っ込んでる
						setline(line[0],line[1],line[2],line[3]) if line.chop!.size == 4
						setbox() if line.index(",") != nil
						setlevel(lev) if line.index(";") != nil
					end
				else
					$info[info_i] = line.to_s.chop
					info_i += 1
				end
			end
		end
		set_bpm()
	end


	def set_file()
		@filename = ARGV[0]

		if File.exist?(@filename) == false
			print @filename + " is not found.\n "
			#next
		else
			@file = open(@filename,"r")
			p "filename: #{@filename}"
		end
	end


	def closefile()
		@file.close
	end

	################BPMS########################
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

	################INFORMATION#################
	def show_info ()
		level = ["Beginner","Easy","Medium","Hard","Challenge"]
		none = "--"
		level.each do |lev|
			if @foot_levels[lev] == 0
				puts sprintf("%10s %5s",lev, none)
				next
			else
				#レベルの出力
				puts sprintf("%10s %5s",lev, @foot_levels[lev])
			end
		end
	end

	##########################このプログラムの中心##########################
	def travel(lev)
		if @levels[lev] == []
			return
		end
		
		#tmp2
		#tmp1
		#nawの順
		tmp1 = 0
		tmp2 = 1
		bpm = $bpms[$bpms.keys[0]]

		#移動距離
		travel = 0

		no_notes = 0
		no_box = 0

		now_mesure = 0.0

		tmp_bo_size = 4
		tmp_notes = 0
		# 計算をしてる 
		@levels[lev].each do |bo|	
			no_notes *= (bo.size.to_f / tmp_bo_size.to_f).to_i
			tmp_bo_size = bo.size if bo.size != 0
			
			bo.each do |lin|
				now_mesure += 1.0/(bo.size/4.0)
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
#print "please iuput level: "
#level_num = gets.to_i
#song.travel(level_num)
song.travel("Hard")
song.travel("Challenge")

song.closefile()
