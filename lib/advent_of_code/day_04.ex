defmodule AdventOfCode.Day04 do
  def part1(input) do
    lines = String.split(input, "\n")

    forward = lines |> forward_search()
    backward = lines |> backward_search()
    top_down = lines |> transpose() |> forward_search()
    bottom_up = lines |> transpose() |> backward_search()

    lines = Enum.map(lines, &String.graphemes/1)

    sub_matrices =
      0..(length(lines) - 1)
      |> Enum.flat_map(fn y ->
        0..(length(Enum.at(lines, y)) - 1)
        |> Enum.map(fn x ->
          extract_4_4_matrix(lines, x, y)
        end)
      end)

    matches = Enum.map(sub_matrices, &count_xmas_diag/1) |> Enum.sum()

    forward + backward + top_down + bottom_up + matches
  end

  defp extract_4_4_matrix(lines, x, y) do
    lines
    |> Enum.drop(y)
    |> Enum.take(4)
    |> Enum.map(fn line -> Enum.drop(line, x) |> Enum.take(4) end)
  end

  defp count_xmas_diag([["X", _, _, "X"], [_, "M", "M", _], [_, "A", "A", _], ["S", _, _, "S"]]),
    do: 2

  defp count_xmas_diag([["X", _, _, "S"], [_, "M", "A", _], [_, "M", "A", _], ["X", _, _, "S"]]),
    do: 2

  defp count_xmas_diag([["S", _, _, "X"], [_, "A", "M", _], [_, "A", "M", _], ["S", _, _, "X"]]),
    do: 2

  defp count_xmas_diag([["S", _, _, "S"], [_, "A", "A", _], [_, "M", "M", _], ["X", _, _, "X"]]),
    do: 2

  defp count_xmas_diag([["X", _, _, _], [_, "M", _, _], [_, _, "A", _], [_, _, _, "S"]]), do: 1
  defp count_xmas_diag([[_, _, _, "X"], [_, _, "M", _], [_, "A", _, _], ["S", _, _, _]]), do: 1
  defp count_xmas_diag([["S", _, _, _], [_, "A", _, _], [_, _, "M", _], [_, _, _, "X"]]), do: 1
  defp count_xmas_diag([[_, _, _, "S"], [_, _, "A", _], [_, "M", _, _], ["X", _, _, _]]), do: 1

  defp count_xmas_diag(_), do: 0

  defp forward_search(lines) do
    Enum.map(lines, fn line ->
      Regex.scan(~r/(XMAS)/, line) |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp backward_search(lines) do
    Enum.map(lines, fn line ->
      Regex.scan(~r/(SAMX)/, line) |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp transpose(lines) do
    lines
    |> Enum.map(&String.graphemes/1)
    |> Enum.filter(fn e -> Enum.count(e) > 0 end)
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.join/1)
  end

  def part2(input) do
    lines = String.split(input, "\n") |> Enum.map(&String.graphemes/1)

    sub_matrices =
      0..(length(lines) - 1)
      |> Enum.flat_map(fn y ->
        0..(length(Enum.at(lines, y)) - 1)
        |> Enum.map(fn x ->
          extract_3_3_matrix(lines, x, y)
        end)
      end)

    Enum.map(sub_matrices, &count_mas_diag/1) |> Enum.sum()
  end

  defp extract_3_3_matrix(lines, x, y) do
    lines
    |> Enum.drop(y)
    |> Enum.take(3)
    |> Enum.map(fn line -> Enum.drop(line, x) |> Enum.take(3) end)
  end

  defp count_mas_diag([["M", _, "M"], [_, "A", _], ["S", _, "S"]]), do: 1
  defp count_mas_diag([["S", _, "M"], [_, "A", _], ["S", _, "M"]]), do: 1
  defp count_mas_diag([["M", _, "S"], [_, "A", _], ["M", _, "S"]]), do: 1
  defp count_mas_diag([["S", _, "S"], [_, "A", _], ["M", _, "M"]]), do: 1
  defp count_mas_diag(_), do: 0
end
