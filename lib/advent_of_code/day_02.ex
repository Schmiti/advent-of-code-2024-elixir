defmodule AdventOfCode.Day02 do
  def part1(input) do
    reports = parse_reports(input)

    reports
    |> Enum.filter(&safe?/1)
    |> Enum.count()
  end

  def part2(input) do
    reports = parse_reports(input)

    reports
    |> Enum.map(&generate_noiseless_reports/1)
    |> Enum.filter(fn noiseless_reports -> Enum.any?(noiseless_reports, &safe?/1) end)
    |> Enum.count()
  end

  defp parse_reports(input) do
    String.split(input, "\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(&Enum.map(&1, fn e -> Integer.parse(e) |> elem(0) end))
    |> Enum.filter(fn e -> not Enum.empty?(e) end)
  end

  defp safe?(report) do
    (increasing?(report) or decreasing?(report)) and adjacent_levels?(report)
  end

  defp increasing?(report), do: Enum.sort(report) == report
  defp decreasing?(report), do: Enum.sort(report) |> Enum.reverse() == report

  defp adjacent_levels?(report) do
    0..(length(report) - 2)
    |> Enum.map(fn i -> abs(Enum.at(report, i) - Enum.at(report, i + 1)) end)
    |> Enum.all?(fn e -> 1 <= e and e <= 3 end)
  end

  defp generate_noiseless_reports(report) do
    0..length(report) |> Enum.map(fn i -> List.delete_at(report, i) end)
  end
end
