require_relative './data'
data = DATA
# data = <<~DATA
#   seeds: 79 14 55 13
#
#   seed-to-soil map:
#   50 98 2
#   52 50 48
#
#   soil-to-fertilizer map:
#   0 15 37
#   37 52 2
#   39 0 15
#
#   fertilizer-to-water map:
#   49 53 8
#   0 11 42
#   42 0 7
#   57 7 4
#
#   water-to-light map:
#   88 18 7
#   18 25 70
#
#   light-to-temperature map:
#   45 77 23
#   81 45 19
#   68 64 13
#
#   temperature-to-humidity map:
#   0 69 1
#   1 0 69
#
#   humidity-to-location map:
#   60 56 37
#   56 93 4
# DATA

def parse(data, mapita_class)
  seeds, *maps = data.delete_prefix("seeds: ").split(/\n\n.+map:\n/)

  seeds = seeds.split(" ").map(&:to_i)
  maps = maps.map { |m| m.split("\n").map { |n| n.split(" ").map(&:to_i)}}.map(&mapita_class.method(:new))
  return seeds, maps
end

describe 'PART 1' do
  class Mapita
    def initialize(rangos)
      @rangos = rangos
    end

    def mapear(numero)
      @rangos.each do |(destination, source, length)|
        if (source...source+length).include?(numero)
          return destination + (numero - source)
        end
      end
      numero
    end
  end

  it 'empty case' do
    mapita = Mapita.new([])

    expect(mapita.mapear(123)).to eq(123)
  end

  it 'test cases' do
    mapita = Mapita.new([[50, 98, 2]])

    expect(mapita.mapear(97)).to eq(97)
    expect(mapita.mapear(98)).to eq(50)
    expect(mapita.mapear(99)).to eq(51)
    expect(mapita.mapear(100)).to eq(100)
  end

  it 'exec' do
    seeds, maps = parse(data, Mapita)
    pp(seeds.map do |seed|
      maps.inject(seed) do |parcial, mapita|
        mapita.mapear(parcial)
      end
    end.min)
  end
end

class Range
  def fragment_by(another_range)
    before = self.begin..[self.end, another_range.begin - 1].min
    intersection = ([self.begin, another_range.begin].max..[self.end, another_range.end].min)
    after = [another_range.end + 1, self.begin].max..self.end

    [before, intersection, after]
  end

  def non_empty?
    size > 0
  end

  def translate_by(delta)
    (self.begin + delta .. self.end + delta)
  end
end

describe 'part2' do
  class Mapita2
    def initialize(rangos)
      @rangos = rangos.map do |(destination, source, length)|
        source_range = (source..source + length - 1)
        delta = destination - source

        [source_range, delta]
      end
    end

    def mapear(rango_inicial)
      resultado = @rangos.reduce({ mapeados: [], por_mapear: [rango_inicial]}) do |parcial, (source_range, delta)|
        left_unchanged = []
        mapped = []

        parcial[:por_mapear].each do |rango|
          before, intersection, after = rango.fragment_by(source_range)

          left_unchanged << before if before.non_empty?
          mapped << intersection.translate_by(delta) if intersection.non_empty?
          left_unchanged << after if after.non_empty?
        end

        { mapeados: parcial[:mapeados] + mapped, por_mapear: left_unchanged }
      end

      resultado[:mapeados] + resultado[:por_mapear]
    end
  end


  it 'empty case' do
    mapita = Mapita2.new([])

    expect(mapita.mapear((100..200))).to eq([(100..200)])
  end

  it 'test cases' do
    mapita = Mapita2.new([[50, 98, 2]])

    expect(mapita.mapear(98..99)).to contain_exactly(50..51)
    expect(mapita.mapear(40..45)).to contain_exactly(40..45)
    expect(mapita.mapear(97..98)).to contain_exactly(97..97, 50..50)
    expect(mapita.mapear(99..100)).to contain_exactly(51..51, 100..100)
    expect(mapita.mapear(95..105)).to contain_exactly(95..97, 50..51, 100..105)
  end

  it 'test cases 2' do
    mapita = Mapita2.new([[100, 200, 10]])

    expect(mapita.mapear(100..199)).to contain_exactly(100..199)
    expect(mapita.mapear(201..205)).to contain_exactly(101..105)
    expect(mapita.mapear(220..250)).to contain_exactly(220..250)
    expect(mapita.mapear(190..220)).to contain_exactly(190..199, 100..109, 210..220)
    expect(mapita.mapear(195..205)).to contain_exactly(195..199, 100..105)
    expect(mapita.mapear(205..220)).to contain_exactly(105..109, 210..220)
  end

  it 'more ranges' do
    mapita = Mapita2.new([[100, 200, 10], [800, 300, 20]])

    expect(mapita.mapear(300..305)).to contain_exactly(800..805)
  end

  it 'exec' do
    seeds, maps = parse(data, Mapita2)
    seed_ranges = seeds.each_slice(2).map { |start, size| (start..start+size-1) }

    pp(seed_ranges.map do |seed_range|
      maps.inject([seed_range]) do |parcial, mapita|
        parcial.flat_map { |seed_range| mapita.mapear(seed_range) }
      end
    end.flatten.map(&:begin).min)
  end
end