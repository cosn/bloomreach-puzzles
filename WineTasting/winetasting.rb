require "csv"

def wines(file)
	wines = Hash.new { |h, k| h[k] = [] }
	people = Hash.new { |h, k| h[k] = [] }
	result = Hash.new { |h, k| h[k] = [] }
	total = 0
	incomplete = 0

	CSV.foreach(file, { :col_sep => "\t" }) do |row|
		wines[row[1]] << row[0]
		people[row[0]] << row[1]
	end

	people.each do |p, w|
		w.each do |wine|
			break if result[p].count == 3
			next if wines[wine] == nil || wines[wine].count > 1

			result[p] << wine
			wines[wine] = nil
			total += 1
		end
	end

	wines.each do |w, p|
		next if p == nil

		p.each do |person|
			next if result[person].count == 3

			result[person] << w
			p = nil
			total += 1
			break
		end
	end

	#wines.each { |k, v| puts "#{k} is wanted by #{v}" if v.count > 1 }
	#people.each { |k, v| puts "#{k} wants #{v}" }
	#result.each { |k, v| puts "#{k} got #{v}" }
	#result.each { |k, v| puts "#{k} did not get his wines (#{v})" if v.count != 3 }
	#result.each_value { |v| incomplete += 1 if v.count != 3 }
	output = File.open("out.txt", 'w')
	output.write("#{total}\n")
	result.each { |k, v| v.each { |vv| output.write("#{k}\t#{vv}\n") } }

	percentSold = total.to_f / wines.length.to_f * 100.0
	percentIncomplete = incomplete / people.length.to_f * 100.0
	puts "Sold #{total} out of #{wines.length} wines (#{percentSold.round(2)}%)"
	puts "#{incomplete} people did not get all their wines (#{percentIncomplete}%)"

end

wines("person_wine_3.txt")
#wines("person_wine_4.txt")
#wines("person_wine_5.txt")
