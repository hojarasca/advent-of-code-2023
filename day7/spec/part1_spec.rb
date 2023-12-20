require_relative './data'
data = DATA
# data = <<~DATA
#   32T3K 765
#   T55J5 684
#   KK677 28
#   KTJJT 220
#   QQQJA 483
# DATA

class Array
  def second
    self[1]
  end
end

describe 'PART 1' do
  it 'exec' do
    cards_with_bids = data.lines.map do |line|
      cards, bid = line.split(" ")
      [cards.chars, bid.to_i]
    end

    lala = cards_with_bids.map do |cards, bid|
      [cards.join(""), value_of_hand(cards), bid]
    end.sort_by(&:second)
    pp lala
    resultado = lala.each_with_index.map do |(card, value, bid), index|
      rank = index + 1
      bid * rank
    end
    pp resultado
    pp resultado.sum
  end

  def value_of_hand(hand)
    [type_of(hand), *hand.map{ |card| value_of(card) }]
  end

  def value_of(card)
    {"A" => 14, "K" => 13, "Q"=> 12, "J"=> 11, "T"=> 10}.fetch(card, &:to_i)
  end

  def type_of(hand)
    groups_of_cards = hand.group_by(&:itself).values
    return 7 if groups_of_cards.size == 1
    return 6 if groups_of_cards.any? { |group| group.size == 4 }
    return 5 if groups_of_cards.size == 2
    return 4 if groups_of_cards.any? { |group| group.size == 3 }
    return 3 if groups_of_cards.count { |group| group.size == 2 } == 2
    return 2 if groups_of_cards.count { |group| group.size == 2 } == 1
    return 1

    # Five of a kind, where all five cards have the same label: AAAAA
    # Four of a kind, where four cards have the same label and one card has a different label: AA8AA
    # Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
    # Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
    # Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
    # One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
    # High card, where all cards' labels are distinct: 23456

  end
end

describe 'PART 2' do
  it 'exec' do
    cards_with_bids = data.lines.map do |line|
      cards, bid = line.split(" ")
      [cards.chars, bid.to_i]
    end

    resultado = cards_with_bids.map do |cards, bid|
      [cards.join(""), value_of_hand(cards), bid]
    end.sort_by(&:second).each_with_index.map do |(card, value, bid), index|
      rank = index + 1
      bid * rank
    end.sum
    pp resultado
  end

  def value_of_hand(hand)
    [type_of(hand), *hand.map{ |card| value_of(card) }]
  end

  def value_of(card)
    {"A" => 14, "K" => 13, "Q"=> 12, "J"=> 1, "T"=> 10}.fetch(card, &:to_i)
  end

  def type_of(hand)
    js, nojs = hand.partition { |card| card == "J" }

    return 7 if nojs.empty?

    grupos_sin_j = nojs.group_by(&:itself)
    carta_mas_popular = grupos_sin_j.values.sort_by(&:size).last.first
    grupos_sin_j[carta_mas_popular] += [carta_mas_popular] * js.size

    groups_of_cards = grupos_sin_j.values
    return 7 if groups_of_cards.size == 1
    return 6 if groups_of_cards.any? { |group| group.size == 4 }
    return 5 if groups_of_cards.size == 2
    return 4 if groups_of_cards.any? { |group| group.size == 3 }
    return 3 if groups_of_cards.count { |group| group.size == 2 } == 2
    return 2 if groups_of_cards.count { |group| group.size == 2 } == 1
    return 1

    # Five of a kind, where all five cards have the same label: AAAAA
    # Four of a kind, where four cards have the same label and one card has a different label: AA8AA
    # Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
    # Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
    # Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
    # One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
    # High card, where all cards' labels are distinct: 23456

  end
end