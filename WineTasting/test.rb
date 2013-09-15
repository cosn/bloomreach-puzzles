require "test/unit"
require "csv"

class WineTastingTests < Test::Unit::TestCase

	@@expectedTotalWinesSold = 0

	@@buyers = Hash.new(0)
	@@wines = Hash.new(0)

	def setup
		CSV.foreach("out.txt", { :col_sep => "\t" }) do |row|
			if (row.count == 1)
				@@expectedTotalWinesSold = row[0].to_i()
			elsif
				@@buyers[row[0]] += 1
				@@wines[row[1]] += 1
			end
		end
	end
	
	def test_all
		assert_equal(@@expectedTotalWinesSold, @@wines.length)
		@@wines.each { |k, v| assert_equal(1, v, "#{k} exists more than once") }
		@@buyers.each { |k, v| assert_equal(3, v, "#{k} does not have the expected number of wines") }
	end
end
