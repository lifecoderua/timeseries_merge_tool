require './file_reader.rb'

class Merger
  def initialize source_folder = './data/input/', result_file = './data/output.csv'
    @file_readers = []
    @target_century = nil

    # initialize FileReaders
    input_files = Dir.glob( File.join(source_folder, '*') )
    input_files.each do |path|
      @file_readers.push FileReader.new(path)
    end
    
    # compute starting point (earliest century)
  end

  def run
    # iterate through centuries and compile ouput file
  end
end