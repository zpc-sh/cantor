defmodule Cantor.Cadence.AST do
  @moduledoc """
  Abstract Syntax Tree definitions for Cadence.
  """

  def function_call(name, args, line) do
    %{
      type: :function_call,
      name: name,
      args: args,
      line: line
    }
  end

  def pipe(left, right, line) do
    %{
      type: :pipe,
      left: left,
      right: right,
      line: line
    }
  end

  def binary_op(operator, left, right, line) do
    %{
      type: :binary_op,
      operator: operator,
      left: left,
      right: right,
      line: line
    }
  end

  def assignment(name, value, line) do
    %{
      type: :assignment,
      name: name,
      value: value,
      line: line
    }
  end

  def literal(value, line) do
    data_type =
      case value do
        v when is_integer(v) -> :integer
        v when is_float(v) -> :float
        v when is_binary(v) -> :string
        v when is_atom(v) -> :atom
      end

    %{
      type: :literal,
      value: value,
      data_type: data_type,
      line: line
    }
  end

  def list(elements, line) do
    %{
      type: :list,
      elements: elements,
      line: line
    }
  end

  def identifier(name, line) do
    %{
      type: :identifier,
      name: name,
      line: line
    }
  end
end
