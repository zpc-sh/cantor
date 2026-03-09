defmodule Cantor.Modalities.ScoreTest do
  use Cantor.DataCase, async: true

  alias Cantor.Modalities.Score

  describe "Score Modality" do
    @valid_attrs %{
      name: "Jungle Break",
      notation: %{"pattern" => "K . S . K K S ."},
      intent: %{"emotion" => "Manic", "complexity" => "High"}
    }
    @update_attrs %{
      name: "Jungle Break Updated",
      notation: %{"pattern" => "K . S . K K S . K"},
      intent: %{"emotion" => "Frantic"}
    }
    @invalid_attrs %{
      name: nil,
      notation: nil,
      intent: nil
    }

    test "create/1 with valid data creates a score" do
      score = Score.create!(@valid_attrs)
      assert score.name == "Jungle Break"
      assert score.notation == %{"pattern" => "K . S . K K S ."}
      assert score.intent == %{"emotion" => "Manic", "complexity" => "High"}
    end

    test "create/1 with invalid data returns error" do
      assert {:error, _} = Score.create(@invalid_attrs)
    end

    test "read/0 returns all scores" do
      score = Score.create!(@valid_attrs)
      assert scores = Score.read!()
      assert length(scores) >= 1
      assert Enum.any?(scores, &(&1.id == score.id))
    end

    test "update/2 with valid data updates the score" do
      score = Score.create!(@valid_attrs)
      updated_score = Score.update!(score, @update_attrs)
      assert updated_score.name == "Jungle Break Updated"
      assert updated_score.notation == %{"pattern" => "K . S . K K S . K"}
      assert updated_score.intent == %{"emotion" => "Frantic"}
    end

    test "destroy/1 deletes the score" do
      score = Score.create!(@valid_attrs)
      assert :ok = Score.destroy(score)
      scores = Score.read!()
      refute Enum.any?(scores, &(&1.id == score.id))
    end
  end
end
