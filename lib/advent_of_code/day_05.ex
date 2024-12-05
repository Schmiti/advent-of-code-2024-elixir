defmodule AdventOfCode.Day05 do
  def part1(input) do
    {rules, updates} = parse(input)

    rules_results =
      Enum.map(rules, &check_rules_appliances(&1, updates))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    Enum.filter(0..(length(rules_results) - 1), fn index ->
      Enum.all?(Enum.at(rules_results, index))
    end)
    |> Enum.map(&Enum.at(updates, &1))
    |> Enum.map(&extract_middle_page_number/1)
    |> Enum.sum()
  end

  def part2(input) do
    {rules, updates} = parse(input)

    rules_results =
      Enum.map(rules, &check_rules_appliances(&1, updates))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    Enum.filter(0..(length(rules_results) - 1), fn index ->
      Enum.any?(Enum.at(rules_results, index), fn e -> e == false end)
    end)
    |> Enum.map(&Enum.at(updates, &1))
    |> Enum.map(fn update ->
      Enum.sort(String.split(update, ","), fn a, b -> sorter(a, b, rules) end)
    end)
    |> Enum.map(&extract_middle_page_number/1)
    |> Enum.sum()
  end

  defp check_rules_appliances(rule, updates) when is_list(updates) do
    Enum.map(updates, &check_rule_appliance(rule, &1))
  end

  defp check_rule_appliance(rule, update) when is_binary(update) do
    {a, b} = rule
    {:ok, regex} = Regex.compile(b <> ".*" <> a)
    # No match means no rule violation, because the regex is the rule in reversed
    not Regex.match?(regex, update)
  end

  defp extract_middle_page_number(update) when is_binary(update) do
    String.split(update, ",") |> extract_middle_page_number()
  end

  defp extract_middle_page_number(page_numbers) when is_list(page_numbers) do
    Enum.at(page_numbers, floor(length(page_numbers) / 2)) |> String.to_integer()
  end

  defp sorter(a, b, rules) do
    {a, b} in rules
  end

  defp parse(input) do
    [rules, updates] = String.split(String.trim(input), "\n\n")

    rules =
      String.split(rules, "\n")
      |> Enum.map(fn e -> Regex.scan(~r/(\d+)|(\d+)/, e) end)
      |> Enum.map(fn [[a, a], [b, b]] -> {a, b} end)

    updates = String.split(updates, "\n")

    {rules, updates}
  end
end
