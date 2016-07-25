require 'fileutils'
require 'date'
require 'csv'
require 'digest'


SOURCE_FOLDER = './data/input/'
TOTAL_FILENAME = './data/etalon_output.csv'
CALCULATED_FILENAME = './data/output.csv'
START_DATE = '1665-05-14' 
END_DATE = '2115-02-23'
INPUT_COUNT = 6  

MAX_VALUE = 50
ACTIVE_DATE_DICE = 20
ACTIVE_INPUT_DICE = 5
  
  
def run
  FileUtils.rm_rf(SOURCE_FOLDER)
  FileUtils.mkdir(SOURCE_FOLDER)
  
  rng = Random.new
  date = Date.parse(START_DATE)
 
  inputs = INPUT_COUNT.times.map { [] }
  output = []
  
  loop do
    date_str = date.to_s
    total = 0
    
    if rng.rand(ACTIVE_DATE_DICE) == 0
      inputs.each do |input|
        if rng.rand(ACTIVE_INPUT_DICE) == 0
          delta = rng.rand(1..MAX_VALUE)
          input.push [date_str, delta]
          total += delta
        end
      end
    end

    output.push [date_str, total] if total != 0
    
    date = date.next_day
    
    break if date_str == END_DATE
  end
  
  inputs.each_with_index do |input, i|
    CSV.open("#{SOURCE_FOLDER}input#{i}.txt", 'wb', :col_sep => ':') do |csv|
      input.each { |line| csv << line }
    end
  end
  
  CSV.open(TOTAL_FILENAME, 'wb', :col_sep => ':') do |csv|
    output.each { |line| csv << line }
  end
  
  `ruby run.rb`
  
  etalon_digest = Digest::SHA256.file TOTAL_FILENAME
  output_digest = Digest::SHA256.file CALCULATED_FILENAME
  
  p "Etalon:     #{etalon_digest}"
  p "Calculated: #{output_digest}"
  
  p etalon_digest === output_digest ? 'OK' : 'Failed'
end


run