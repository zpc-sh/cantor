defmodule Cantor.Cadence.TokenizerTest do
  use ExUnit.Case

  alias Cantor.Cadence.Tokenizer

  test "tokenizes simple function call" do
    {:ok, tokens} = Tokenizer.tokenize("kick(every: 4)")

    assert tokens == [
             {:identifier, "kick", 1},
             {:lparen, "(", 1},
             {:identifier, "every", 1},
             {:colon, ":", 1},
             {:integer, 4, 1},
             {:rparen, ")", 1}
           ]
  end

  test "tokenizes pipe with visualizer" do
    {:ok, tokens} = Tokenizer.tokenize("kick |> visualize(:waveform)")

    types = Enum.map(tokens, fn {type, _, _} -> type end)
    assert types == [:identifier, :pipe, :identifier, :lparen, :atom, :rparen]
  end

  test "tokenizes addition" do
    {:ok, tokens} = Tokenizer.tokenize("drums + bass")

    assert tokens == [
             {:identifier, "drums", 1},
             {:plus, "+", 1},
             {:identifier, "bass", 1}
           ]
  end
end
