defmodule Cantor.Cadence.CompilerTest do
  use ExUnit.Case

  alias Cantor.Cadence.{Parser, Compiler}

  test "compiles kick to JSON-LD fingerprint" do
    {:ok, ast} = Parser.parse("kick(every: 4)")
    fingerprint = Compiler.compile(ast, :fingerprint)

    assert fingerprint["@type"] == "cadence:Composition"

    [kick_fp] = fingerprint["@graph"]
    assert kick_fp["@type"] == "cadence:DrumHit"
    assert kick_fp["instrument"] == "kick"
    assert kick_fp["frequency"]["fundamental"] == 60
  end

  test "compiles pipe to processing pipeline" do
    {:ok, ast} = Parser.parse("kick(every: 4) |> visualize(:waveform)")
    fingerprint = Compiler.compile(ast, :fingerprint)

    [pipeline] = fingerprint["@graph"]
    assert pipeline["@type"] == "cadence:Pipeline"
    assert pipeline["input"]["instrument"] == "kick"
    assert pipeline["processing"]["@type"] == "cadence:Visualizer"
  end

  test "includes JSON-LD context" do
    {:ok, ast} = Parser.parse("kick(every: 4)")
    fingerprint = Compiler.compile(ast, :fingerprint)

    context = fingerprint["@context"]
    assert context["@vocab"] == "https://cantor.com/cadence/v2/"
  end
end
