#print "input file name: "
#name = gets.to_s.chop
$file = open("travel.csv","r")
$f_arr = Array.new()

def standard()

	$before_std = 0.0
	adder = 0.0

	$f_arr.each do |line|
		adder += (line.split(";")[2].to_f - $ave)**2
	end
	$before_std = Math.sqrt(adder/$i.to_f)
end

def calclate_std (num)
	return (($f_arr[num].split(";").last.to_f - $ave)/$before_std)*10 + 50
end

def test_std (num)
	print "result: "
	puts calclate_std(num)
	puts $f_arr[num]
end

def output_csv ()
	csv_file = open("result.csv","w")
	i = 0
	arr = Array.new()
	$f_arr.each do |line|
		arr = line.split(";")
		#puts arr.size
		#str0 = "%s," %[#{arr[0]}]
		#str1 = "%30s," %[#{arr[1]}]
		#str2 = "%3.4f" %[#{calclate_std(i)}]
		#csv_file.sprintf("%s,%30s,%3.4f" arr[0],arr[1],calclate_std(i))
		#csv_file.write str0
	#	csv_file.print str1
	#	csv_file.print str2
	#	csv_file.puts
		csv_file.print "#{arr[0]},#{arr[1]},#{calclate_std(i)}\n"

		i += 1
	end
	csv_file.close
end


$i = 0
sum = 0

$file.each do |line|
	$f_arr.push(line)
	sum += line.to_s.split(";")[2].to_f

	$i += 1
end

puts "sum: #{sum}"
puts "i: #{$i}"
$ave = sum/$i
puts "ave: #{$ave}"

puts "std: #{standard()}"

output_csv()

#while (num = gets.to_i > 0) do
#loop do
#	print "input number:"
#	num = gets.to_i

#	break if num < 0
	#print_std(num)
#end

$file.close

