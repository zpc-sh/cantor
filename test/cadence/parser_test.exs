defmodule Cantor.Cadence.ParserTest do
  use ExUnit.Case

  alias Cantor.Cadence.Parser

  test "parses simple function call" do
    {:ok, [ast]} = Parser.parse("kick(every: 4)")

    assert ast.type == :function_call
    assert ast.name == "kick"
    assert length(ast.args) == 1

    [arg] = ast.args
    assert arg.type == :keyword_arg
    assert arg.key == :every
    assert arg.value.value == 4
  end

  test "parses pipe expression" do
    {:ok, [ast]} = Parser.parse("kick(every: 4) |> visualize(:waveform)")

    assert ast.type == :pipe
    assert ast.left.type == :function_call
    assert ast.left.name == "kick"

    assert ast.right.type == :function_call
    assert ast.right.name == "visualize"

    [viz_arg] = ast.right.args
    assert viz_arg.value == :waveform
  end

  test "parses assignment" do
    {:ok, [ast]} = Parser.parse("drums = kick(every: 4)")

    assert ast.type == :assignment
    assert ast.name == "drums"
    assert ast.value.type == :function_call
    assert ast.value.name == "kick"
  end

  test "parses binary operation" do
    {:ok, [ast]} = Parser.parse("drums + bass")

    assert ast.type == :binary_op
    assert ast.operator == :plus
    assert ast.left.name == "drums"
    assert ast.right.name == "bass"
  end

  test "parses complex expression" do
    {:ok, [ast]} =
      Parser.parse("track = kick(every: 4) + snare(every: 8) |> visualize(:spectrum)")

    assert ast.type == :assignment
    assert ast.name == "track"
    assert ast.value.type == :pipe

    # Left side is addition
    left = ast.value.left
    assert left.type == :binary_op
    assert left.operator == :plus

    # Right side is visualize
    right = ast.value.right
    assert right.name == "visualize"
  end

  test "returns error when string to existing atom fails" do
    # Generate a unique atom name that shouldn't exist
    unique_key = "non_existent_key_#{System.unique_integer([:positive])}"

    # This should fail because String.to_existing_atom will raise ArgumentError
    # But Parser.parse_tokens rescues all errors and returns {:error, ...}
    assert {:error, message} = Parser.parse("kick(#{unique_key}: 4)")
    assert message =~ "ArgumentError"
  end
end
