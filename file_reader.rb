# require 'date'
require 'CSV'
BATCH_SIZE = 100

class FileReader
  attr_reader :century
  @csv 
  @buffer

  def initialize path
    # open file
    handle = File.open(path)
    @csv = CSV.new(handle, col_sep: ':')
    @buffer = []

p pick 
    # read+parse first entry
    # set next century
  end

  def next
    # return data block until next century, data length limit or EOF 
  end

  def pick
    # [date, val]
    @csv.readline 
  end
end


