require 'set'
require_relative './data'
data = DATA
# data = <<~DATA
#   RL
#
#   AAA = (BBB, CCC)
#   BBB = (DDD, EEE)
#   CCC = (ZZZ, GGG)
#   DDD = (DDD, DDD)
#   EEE = (EEE, EEE)
#   GGG = (GGG, GGG)
#   ZZZ = (ZZZ, ZZZ)
# DATA
# data = <<~DATA
#   LLR
#
#   AAA = (BBB, BBB)
#   BBB = (AAA, ZZZ)
#   ZZZ = (ZZZ, ZZZ)
# DATA


describe 'PART 1' do
  it 'exec' do
    instrucciones, _, *nodos_con_conexiones = data.lines
    pp instrucciones.strip!
    red = nodos_con_conexiones.map { |n| n.split(" = ") }.map do |nodo, conexiones|
      [nodo, ["L", "R"].zip(conexiones.strip.delete_prefix("(").delete_suffix(")").split(", ")).to_h]
    end.to_h
    nodo = "AAA"
    pasos = instrucciones.chars.cycle.each_with_index do |instruccion, i|
      break i if nodo == "ZZZ"
      nodo = red[nodo][instruccion]
    end
    pp pasos
  end
end

# data2 = <<~DATA
# LR
#
# 11A = (11B, XXX)
# 11B = (XXX, 11Z)
# 11Z = (11B, XXX)
# 22A = (22B, XXX)
# 22B = (22C, 22C)
# 22C = (22Z, 22Z)
# 22Z = (22B, 22B)
# XXX = (XXX, XXX)
# DATA
data2 = DATA

describe 'PART 2' do
  it 'exec' do
    instrucciones, _, *nodos_con_conexiones = data2.lines
    pp instrucciones.strip!
    red = nodos_con_conexiones.map { |n| n.split(" = ") }.map do |nodo, conexiones|
      [nodo, ["L", "R"].zip(conexiones.strip.delete_prefix("(").delete_suffix(")").split(", ")).to_h]
    end.to_h
    nodos = red.keys.filter { |n| n.end_with?("A") }
    result = nodos.map do |nodo|
      veces = 0
      nodo_actual = nodo
      instrucciones.chars.cycle.each_with_index do |instruccion, i|
        veces += 1 if nodo_actual.end_with?("Z")
        break i if veces == 1
        nodo_actual = red[nodo_actual][instruccion]
      end
    end.reduce(:lcm)
    pp result
  end
end

