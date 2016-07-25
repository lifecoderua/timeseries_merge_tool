require './file_reader.rb'

class Merger
  @result_file
  def initialize source_folder = './data/input/', result_file = './data/output.csv'
    @file_readers = []
    @result_file = result_file

    input_files = Dir.glob( File.join(source_folder, '*') )
    input_files.each do |path|
      @file_readers.push FileReader.new(path)
    end
  end

  def run
    target_century = current_century = next_target_century
    merge_results = {}
    
    CSV.open(@result_file, 'wb', col_sep: ':') do |csv|
      until @file_readers.empty? do
        @file_readers.select { |file_reader| file_reader.century == target_century }.each do |file_reader|
          merge_results.merge!(file_reader.next.to_h) { |k, val1, val2| val1 + val2 }
        end
        
        target_century = next_target_century
        
        if current_century != target_century
          merge_results.sort.each { |line| csv << line }
          merge_results = {}
          current_century = target_century
        end
        
        @file_readers.reject!(&:eof?)
      end
      
      merge_results.sort.each { |line| csv << line }
    end
  end

private
  
  def next_target_century
    @file_readers.min_by(&:century).century
  end
end