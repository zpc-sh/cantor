defmodule Cantor.Cadence.Parser do
  alias Cantor.Cadence.{Tokenizer, AST}

  def parse(source) when is_binary(source) do
    with {:ok, tokens} <- Tokenizer.tokenize(source) do
      parse_tokens(tokens)
    end
  end

  def parse_tokens(tokens) do
    try do
      {ast, remaining} = parse_statements(tokens, [])
      case remaining do
        [] -> {:ok, ast}
        _ -> {:error, "Unexpected tokens: #{inspect(remaining)}"}
      end
    rescue
      error -> {:error, "Parse error: #{inspect(error)}"}
    end
  end

  defp parse_statements([], acc), do: {Enum.reverse(acc), []}
  
  defp parse_statements(tokens, acc) do
    {statement, remaining} = parse_statement(tokens)
    parse_statements(remaining, [statement | acc])
  end

  defp parse_statement(tokens) do
    case tokens do
      [{:identifier, name, line}, {:assign, _, _} | rest] ->
        {value, remaining} = parse_expression(rest)
        {AST.assignment(name, value, line), remaining}
      _ ->
        parse_expression(tokens)
    end
  end

  defp parse_expression(tokens) do
    parse_pipe(tokens)
  end

  defp parse_pipe(tokens) do
    {left, remaining} = parse_addition(tokens)
    parse_pipe_rest(left, remaining)
  end

  defp parse_pipe_rest(left, [{:pipe, _, line} | tokens]) do
    {right, remaining} = parse_addition(tokens)
    pipe_expr = AST.pipe(left, right, line)
    parse_pipe_rest(pipe_expr, remaining)
  end
  
  defp parse_pipe_rest(left, tokens), do: {left, tokens}

  defp parse_addition(tokens) do
    {left, remaining} = parse_primary(tokens)
    parse_addition_rest(left, remaining)
  end

  defp parse_addition_rest(left, [{:plus, _, line} | tokens]) do
    {right, remaining} = parse_primary(tokens)
    add_expr = AST.binary_op(:plus, left, right, line)
    parse_addition_rest(add_expr, remaining)
  end
  
  defp parse_addition_rest(left, tokens), do: {left, tokens}

  defp parse_primary(tokens) do
    case tokens do
      # Function call: identifier(args...) - must come before plain identifier
      [{:identifier, name, line}, {:lparen, _, _} | rest] ->
        {args, remaining} = parse_function_args(rest)
        {AST.function_call(name, args, line), remaining}
        
      # Plain identifier
      [{:identifier, name, line} | rest] ->
        {AST.identifier(name, line), rest}
        
      [{type, value, line} | rest] when type in [:integer, :float, :atom] ->
        {AST.literal(value, line), rest}
        
      [{:lbracket, _, line} | rest] ->
        {elements, remaining} = parse_list_elements(rest)
        {AST.list(elements, line), remaining}
        
      tokens ->
        raise "Unexpected token: #{inspect(List.first(tokens))}"
    end
  end

  defp parse_function_args(tokens) do
    case tokens do
      [{:rparen, _, _} | rest] -> {[], rest}
      _ ->
        {args, remaining} = parse_arg_list(tokens, [])
        case remaining do
          [{:rparen, _, _} | final] -> {args, final}
          _ -> raise "Expected )"
        end
    end
  end

  defp parse_arg_list(tokens, acc) do
    case tokens do
      [{:rparen, _, _} | _] -> {Enum.reverse(acc), tokens}
      _ ->
        {arg, remaining} = parse_argument(tokens)
        case remaining do
          [{:comma, _, _} | rest] -> parse_arg_list(rest, [arg | acc])
          _ -> {Enum.reverse([arg | acc]), remaining}
        end
    end
  end

  defp parse_argument(tokens) do
    case tokens do
      # Keyword argument: identifier: value  
      [{:identifier, key, line}, {:colon, _, _} | rest] ->
        {value, remaining} = parse_expression(rest)
        keyword_arg = %{type: :keyword_arg, key: String.to_existing_atom(key), value: value, line: line}
        {keyword_arg, remaining}
      # Also support atoms: :key, value
      [{:atom, key, line}, {:colon, _, _} | rest] ->
        {value, remaining} = parse_expression(rest)
        keyword_arg = %{type: :keyword_arg, key: key, value: value, line: line}
        {keyword_arg, remaining}
      _ ->
        parse_expression(tokens)
    end
  end

  defp parse_list_elements(tokens) do
    case tokens do
      [{:rbracket, _, _} | rest] -> {[], rest}
      _ ->
        {elements, remaining} = parse_element_list(tokens, [])
        case remaining do
          [{:rbracket, _, _} | final] -> {elements, final}
          _ -> raise "Expected ]"
        end
    end
  end

  defp parse_element_list(tokens, acc) do
    case tokens do
      [{:rbracket, _, _} | _] -> {Enum.reverse(acc), tokens}
      _ ->
        {element, remaining} = parse_expression(tokens)
        case remaining do
          [{:comma, _, _} | rest] -> parse_element_list(rest, [element | acc])
          _ -> {Enum.reverse([element | acc]), remaining}
        end
    end
  end
end