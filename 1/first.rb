# frozen_string_literal: true

sums = {}
solution = 0

File.foreach('input.txt') do |line|
  num = line.to_i
  solution = num * (2020 - num) if sums.key?(num)
  sums[2020 - num] = num
end

puts solution
