defmodule AdventOfCode.Day03 do
  def part1(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, input)
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.replace("\n", "")
    |> String.replace(~r/don't\(\)(.*)do\(\)/U, "")
    |> part1()
  end
end
