defmodule Cantor.Cadence.ASTTest do
  use ExUnit.Case

  alias Cantor.Cadence.AST

  describe "binary_op/4" do
    test "returns a binary_op map with the given arguments" do
      operator = :+
      left = %{type: :literal, value: 1, data_type: :integer, line: 1}
      right = %{type: :literal, value: 2, data_type: :integer, line: 1}
      line = 1

      expected = %{
        type: :binary_op,
        operator: operator,
        left: left,
        right: right,
        line: line
      }

      assert AST.binary_op(operator, left, right, line) == expected
    end
  end
end
