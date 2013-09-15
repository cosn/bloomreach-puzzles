require "csv"

@winesPerPerson = 3

def wines(input, output)
    wines = Hash.new { |h, k| h[k] = [] }
    people = Hash.new { |h, k| h[k] = [] }
    result = Hash.new { |h, k| h[k] = [] }
    total = 0
    incomplete = 0

    # load the file in two dimensions: 
    #   wines with all the people that want them
    #   and people with all the wines they wany
    CSV.foreach(input, { :col_sep => "\t" }) do |row|
        wines[row[1]] << row[0]
        people[row[0]] << row[1]
    end

    # go through each person and have them buy wines
    # if they are the only one who want a wine, give it to them
    # do not give anyone wines under contention by several people
    people.each do |p, w|
        w.each do |wine|
            break if result[p].count == @winesPerPerson
            next if wines[wine] == nil || wines[wine].count > 1

            # count the total wines sold and mark them as such
            result[p] << wine
            wines[wine] = nil
            total += 1
        end
    end

    # whatever wines are left are under contention
    # give each wine to the first person in the list that wants it
    # and still hasn't received a wine
    wines.each do |w, p|
        next if p == nil

        p.each do |person|
            next if result[person].count == @winesPerPerson

            result[person] << w
            p = nil
            total += 1
            break
        end
    end

    out = File.open(output, 'w')
    out.write("#{total}\n")
    result.each do |k, v| 
        v.each { |vv| out.write("#{k}\t#{vv}\n") }
        incomplete += 1 if v.count != @winesPerPerson
    end
    puts "Results saved in #{output}"

    percentSold = total.to_f / wines.length.to_f * 100.0
    percentIncomplete = incomplete / people.length.to_f * 100.0
    puts "Sold #{total} out of #{wines.length} wines (#{percentSold.round(2)}%)"
    puts "#{incomplete} people did not get all #{@winesPerPerson} wines (#{percentIncomplete}%)"
end

wines("person_wine_3.txt", "out.txt")
#wines("person_wine_4.txt", "out.txt")
#wines("person_wine_5.txt", "out.txt")
