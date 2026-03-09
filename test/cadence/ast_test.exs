defmodule Cantor.Cadence.ASTTest do
  use ExUnit.Case, async: true
  alias Cantor.Cadence.AST

  test "pipe/3 returns a pipe node map" do
    left = %{type: :identifier, name: "foo", line: 1}
    right = %{type: :identifier, name: "bar", line: 1}

    result = AST.pipe(left, right, 2)

    assert result == %{
             type: :pipe,
             left: left,
             right: right,
             line: 2
           }
  end
end
