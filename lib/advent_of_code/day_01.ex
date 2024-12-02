defmodule AdventOfCode.Day01 do
  def part1(input) do
    {first_group, second_group} = extract_location_lists(input)
    first_group = Enum.sort(first_group)
    second_group = Enum.sort(second_group)

    Enum.zip(first_group, second_group)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2(input) do
    {first_group, second_group} = extract_location_lists(input)

    Enum.map(first_group, fn e -> {e, count_occurences(second_group, e)} end)
    |> Enum.map(fn {e, cnt} -> e * cnt end)
    |> Enum.sum()
  end

  defp extract_location_lists(input) do
    tmp_input =
      String.split(input, "\n")
      |> Enum.map(&String.split/1)
      |> Enum.filter(fn e -> not Enum.empty?(e) end)

    first_group = Enum.map(tmp_input, fn [a, _] -> Integer.parse(a) |> elem(0) end)
    second_group = Enum.map(tmp_input, fn [_, b] -> Integer.parse(b) |> elem(0) end)

    {first_group, second_group}
  end

  defp count_occurences(group, element), do: Enum.count(group, fn e -> e == element end)
end
