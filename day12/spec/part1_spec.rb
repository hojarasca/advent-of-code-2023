require_relative './data'
# data = DATA
data = <<~DATA
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
DATA



describe 'PART 1' do
  it "a" do
    lines = data.split("\n")

    lines.each do |line|
      spring_values, groups = line.split(" ")
      groups = groups.split(",").map(&:to_i)
      puts "Spring values: #{spring_values}"
      puts groups.inspect
    end

    expect(lines).to eq 2
  end
end