require 'csv'
require 'descriptive_statistics'

panelist=[]
application=[]
score=[]
zscore=[]
arrhash=[]

CSV.foreach("zscore_input.csv", :headers => :first_row, :return_headers => false) do |row| 
panelist << row[0]
application << row[1]
score << row[2]
end
mean=score.uniq.mean
std_dev=score.uniq.standard_deviation
1.upto(score.length){|i| zscore << ((score[i].to_f - mean)/std_dev)}
#puts zscore

0.upto (panelist.length-1) do |idx| 
  arrhash.push({"panelist" => panelist[idx],"application" => application[idx], "score" => score[idx], "zscore" => zscore[idx]})  
end
arrhash.sort_by! {|z|z["zscore"]}
arrhash.reverse!

CSV.open('zscore_output.csv','wb', col_sep: "\t") do |csvfile|
  csvfile << arrhash.first.keys
  arrhash.each do |row|
    csvfile << row.values
  end
end
