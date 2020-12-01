# frozen_string_literal: true

input = File.open('input.txt').readlines.map(&:to_i)

first_order_sums = []

input.each do |x|
  first_order_sums << (2020 - x)
end

solution = 0

first_order_sums.each do |p|
  second_order_sums = {}
  input.each do |x|
    next if 2020 - p == x

    solution = x * (p - x) * (2020 - p) if second_order_sums.key?(x)
    second_order_sums[p - x] = x
  end
end

puts solution
