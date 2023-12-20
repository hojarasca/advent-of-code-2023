require_relative './data'
data = DATA
# data = <<~DATA
#   Time:      71530
#   Distance:  940200
# DATA

class Race
  def initialize(last_record, distance)
    @last_record = last_record
    @distance = distance
  end

  def calc
    (0..@last_record).count do |ms|
      (@last_record - ms) * ms > @distance
    end
  end
end

describe 'PART 1' do
  it 'empty case' do
    times, distances = data.lines.map { |line| line.split(":").last.split(" ").map(&:to_i) }



    a = times.zip(distances).map do |(time, distance)|
      Race.new(time, distance).calc
    end
    pp a.reduce(:*)
  end
end