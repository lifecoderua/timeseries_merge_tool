require './file_reader.rb'

class Merger
  def initialize source_folder = './data/input/', result_file = './data/output.csv'
    @file_readers = []

    # initialize FileReaders
    input_files = Dir.glob( File.join(source_folder, '*') )
    input_files.each do |path|
      @file_readers.push FileReader.new(path)
    end
  end

  def next_target_century
    @file_readers.min_by(&:century).century
  end

  def run
    # iterate through centuries and compile ouput file
    until @file_readers.empty? do
      merge_results = {}

      target_century = self.next_target_century
      @file_readers.select { |file_reader| file_reader.century == target_century }.each do |file_reader|
        merge_results.merge!(file_reader.next.to_h) { |k, val1, val2| val1 + val2 }
        # p file_reader.next.inspect
      end

      @file_readers.reject!(&:eof?)
      # #sort => array
      p merge_results.sort.inspect
    end
  end
end