defmodule Passport do
  def is_valid?(p) do
    Passport.byr_valid?(p) &&
    Passport.iyr_valid?(p) &&
    Passport.eyr_valid?(p) &&
    Passport.hgt_valid?(p) &&
    Passport.hcl_valid?(p) &&
    Passport.ecl_valid?(p) &&
    Passport.pid_valid?(p)
  end

  def byr_valid?(p) do
    Map.has_key?(p, "byr") &&
    Regex.match?(~r/^\d{4}$/, Map.get(p, "byr")) &&
    Map.get(p, "byr") |> String.to_integer() |> (fn x -> 1920 <= x && x <= 2002 end).()
  end

  def iyr_valid?(p) do
    Map.has_key?(p, "iyr") &&
    Regex.match?(~r/^\d{4}$/, Map.get(p, "iyr")) &&
    Map.get(p, "iyr") |> String.to_integer() |> (fn x -> 2010 <= x && x <= 2020 end).()
  end

  def eyr_valid?(p) do
    Map.has_key?(p, "eyr") &&
    Regex.match?(~r/^\d{4}$/, Map.get(p, "eyr")) &&
    Map.get(p, "eyr") |> String.to_integer() |> (fn x -> 2020 <= x && x <= 2030 end).()
  end

  def hgt_valid?(p) do
    Map.has_key?(p, "hgt") &&
    Regex.match?(~r/(^\d{3}cm$)|(^\d{2}in$)/, Map.get(p, "hgt")) && (
      Regex.match?(~r/^(\d{3})cm$/, Map.get(p, "hgt")) &&
      Regex.replace(~r/^(\d{3})cm$/, Map.get(p, "hgt"), "\\g{1}") |> String.to_integer() |> (fn x -> 150 <= x && x <= 193 end).() ||

      Regex.match?(~r/^(\d{2})in$/, Map.get(p, "hgt")) &&
      Regex.replace(~r/^(\d{2})in$/, Map.get(p, "hgt"), "\\g{1}") |> String.to_integer() |> (fn x -> 59 <= x && x <= 76 end).()
    )
  end

  def hcl_valid?(p) do
    Map.has_key?(p, "hcl") &&
    Regex.match?(~r/^#[0-9a-f]{6}$/, Map.get(p, "hcl"))
  end

  def ecl_valid?(p) do
    Map.has_key?(p, "ecl") &&
    MapSet.member?(MapSet.new(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]), Map.get(p, "ecl"))
  end

  def pid_valid?(p) do
    Map.has_key?(p, "pid") &&
    Regex.match?(~r/^\d{9}$/, Map.get(p, "pid"))
  end
end

{:ok, contents} = File.read("input.txt")

contents
|> String.split("\n\n")
|> Enum.map(fn s -> String.split(s) |> Enum.map(fn x -> String.split(x, ":") end) end)
|> Enum.map(fn s -> Map.new(s, fn x -> {Enum.at(x, 0), Enum.at(x, 1)} end) end)
|> Enum.count(&Passport.is_valid?/1)
|> IO.puts()
