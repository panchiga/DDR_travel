=begin
#file open
filename = gets.chop
file = open(filename)
=end


=begin
#print all line

file.each do |line|
	puts line

end
=end

class Mscore
	attr_accessor :lines 
	attr_accessor :box

	def initialize 
		@lines = Array.new()
		@box = Array.new()
	end
	def setlines(l1,l2,l3,l4)
		line = [l1,l2,l3,l4]
		@lines.push(line)
	end

	def setbox()
		@box.push(@lines)
		@box.push(@lines)
		
	end

	def print()
		p @box
	end
end

#main
test = Mscore.new()

arr = [
	[0,1,0,0],
	[0,0,0,1],
	[0,1,0,0],
	[0,0,1,0],
	[1,0,0,0],
	[0,1,0,0],
	[0,0,0,1],
	[0,0,1,0]
]
puts arr.size
arr.each do |i|
	test.setlines(i[0],i[1],i[2],i[3])
	puts
end
test.setbox()
test.print()

=begin
#file search, return counts in string
hage.index

=end

=begin 
#split
hage = "hage,aaa"
array = hage.split(",")
puts array[0]
=end

#file = open('sm','r')
#hage = file.grep(/\sBeginner:\r\n\s2.*/m)

#p hage[0]

#'grep -A 2 -n '

=begin
#after
grepして難易度を撮ってきて表示するやつ


require "open3"
out = Array.new()

level = ["Beginner","Easy","Medium","Hard","Challenge"]
level.size.times do |tmp|
	out, err, stat = Open3.capture3("grep -A 1 #{level[tmp]} sm")
	out_arr = out.split("\r\n")
	puts "#{out_arr[0]} #{out_arr[1]}"
end
str = ["string","line","test"]

puts `echo #{str[0]}`

=end

=begin
before
grepしてなんいどとってくるやつ
	level = Array.new()
	level = file.grep(/(Beginner|Easy|Medium|Hard|Challenge):\r\n\s[0-9].*/m)
	level.size.times do |i|
		puts level[i]
	end


=end
