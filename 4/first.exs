defmodule Passport do
  def isValid(s) do
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    |> Enum.all?(fn (c) -> Enum.member?(s, c) end)
  end
end

{:ok, contents} = File.read("input.txt")

contents
|> String.split("\n\n")
|> Enum.map(&String.split/1)
|> Enum.map(fn (s) -> s |> Enum.map(fn (x) -> String.split(x, ":") |> Enum.at(0) end) end)
|> Enum.count(&Passport.isValid/1)
|> IO.puts()
