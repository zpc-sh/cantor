defmodule Cantor.Cadence.Tokenizer do
  @moduledoc """
  Tokenizer for the Cadence music programming language.
  """

  @type token :: {atom(), any(), integer()}

  def tokenize(source) do
    source
    |> String.split("\n", trim: false)
    |> Enum.with_index(1)
    |> Enum.flat_map(&tokenize_line/1)
    |> filter_noise()
    |> then(&{:ok, &1})
  end

  defp tokenize_line({line, line_number}) do
    tokenize_recursive(line, line_number, [])
  end

  defp tokenize_recursive("", _line_number, acc), do: Enum.reverse(acc)

  defp tokenize_recursive(line, line_number, acc) do
    case next_token(line) do
      {token_type, value, rest} ->
        token = {token_type, value, line_number}
        tokenize_recursive(rest, line_number, [token | acc])
      
      nil ->
        # Skip unrecognized character
        <<_::binary-size(1), rest::binary>> = line
        tokenize_recursive(rest, line_number, acc)
    end
  end

  defp next_token(line) do
    cond do
      # Pipe operator
      String.starts_with?(line, "|>") ->
        {:pipe, "|>", String.slice(line, 2..-1//1)}
      
      # Operators  
      String.starts_with?(line, ">>") ->
        {:sequence, ">>", String.slice(line, 2..-1//1)}
      String.starts_with?(line, "+") ->
        {:plus, "+", String.slice(line, 1..-1//1)}
      String.starts_with?(line, "*") ->
        {:multiply, "*", String.slice(line, 1..-1//1)}
      String.starts_with?(line, "=") ->
        {:assign, "=", String.slice(line, 1..-1//1)}
      
      # Delimiters
      String.starts_with?(line, "(") ->
        {:lparen, "(", String.slice(line, 1..-1//1)}
      String.starts_with?(line, ")") ->
        {:rparen, ")", String.slice(line, 1..-1//1)}
      String.starts_with?(line, "[") ->
        {:lbracket, "[", String.slice(line, 1..-1//1)}
      String.starts_with?(line, "]") ->
        {:rbracket, "]", String.slice(line, 1..-1//1)}
      String.starts_with?(line, ",") ->
        {:comma, ",", String.slice(line, 1..-1//1)}
      # Atoms first (before colon)
      match = Regex.run(~r/^:([a-zA-Z_][a-zA-Z0-9_]*)/, line) ->
        [match_str, atom_name] = match
        {:atom, String.to_atom(atom_name), String.slice(line, String.length(match_str)..-1//1)}
      
      String.starts_with?(line, ":") ->
        {:colon, ":", String.slice(line, 1..-1//1)}
      
      # Numbers
      match = Regex.run(~r/^(\d+\.\d+)/, line) ->
        [match_str, number] = match
        {:float, String.to_float(number), String.slice(line, String.length(match_str)..-1//1)}
      
      match = Regex.run(~r/^(\d+)/, line) ->
        [match_str, number] = match
        {:integer, String.to_integer(number), String.slice(line, String.length(match_str)..-1//1)}
      
      # String literals
      match = Regex.run(~r/^"([^"]*)"/, line) ->
        [match_str, string_content] = match
        {:string, string_content, String.slice(line, String.length(match_str)..-1//1)}
      
      # Identifiers
      match = Regex.run(~r/^([a-zA-Z_][a-zA-Z0-9_]*)/, line) ->
        [match_str, identifier] = match
        {:identifier, identifier, String.slice(line, String.length(match_str)..-1//1)}
      
      # Whitespace
      match = Regex.run(~r/^(\s+)/, line) ->
        [match_str, _] = match
        {:whitespace, nil, String.slice(line, String.length(match_str)..-1//1)}
      
      # Comments
      match = Regex.run(~r/^(#[^\n]*)/, line) ->
        [match_str, _] = match
        {:comment, nil, String.slice(line, String.length(match_str)..-1//1)}
      
      true -> nil
    end
  end

  defp filter_noise(tokens) do
    Enum.reject(tokens, fn {type, _, _} -> 
      type in [:whitespace, :comment] 
    end)
  end
end