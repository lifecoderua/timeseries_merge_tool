require 'CSV'
BATCH_SIZE = 100

class FileReader
  attr_reader :century
  @csv
  @buffer
  @next_line

  def initialize path
    handle = File.open(path)
    @csv = CSV.new(handle, col_sep: ':', converters: :numeric)
    @next_line = nil
    @buffer = []
    pick
  end

  def eof?
    @next_line.nil?
  end

  def next
    @buffer = []
    current_century = @century

    BATCH_SIZE.times do
      readline
      century_changed = current_century != @century
      break if century_changed || eof?  
    end

    @buffer
  end
  
private  

  def pick
    @next_line = @csv.readline 
    return nil if @next_line.nil?
    @century = @next_line.first[0..1]

    @next_line
  end

  def readline 
    @buffer << @next_line
    pick
  end
end


