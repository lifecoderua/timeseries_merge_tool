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

  def next_target_century
    @file_readers.min_by(&:century).century
  end

  def run
    CSV.open(@result_file, 'wb', col_sep: ':') do |csv|
      until @file_readers.empty? do
        merge_results = {}

        target_century = self.next_target_century
        @file_readers.select { |file_reader| file_reader.century == target_century }.each do |file_reader|
          merge_results.merge!(file_reader.next.to_h) { |k, val1, val2| val1 + val2 }
        end

        @file_readers.reject!(&:eof?)
        merge_results.sort.each { |line| csv << line }
      end
    end
  end
end