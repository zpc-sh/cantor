defmodule Cantor.Music.PatternTest do
  use Cantor.DataCase
  import Ash.Query

  alias Cantor.Music.Pattern

  describe "pattern resource" do
    test "create pattern with valid attributes" do
      attrs = %{
        name: "Test Pattern",
        pattern_type: :rhythm,
        cadence_code: "kick(every: 4)"
      }

      assert {:ok, %Pattern{} = pattern} = Ash.create(Pattern, attrs, action: :create)
      assert pattern.name == "Test Pattern"
      assert pattern.pattern_type == :rhythm
      assert pattern.cadence_code == "kick(every: 4)"
      assert pattern.is_public == false
      assert pattern.difficulty_level == 5
      assert pattern.bpm_range == %{"min" => 60, "max" => 200}
      assert pattern.parameters == %{}
      assert pattern.performance_signature == %{}
    end

    test "create pattern missing required name" do
      attrs = %{
        pattern_type: :rhythm,
        cadence_code: "kick(every: 4)"
      }

      assert {:error, %Ash.Error.Invalid{}} = Ash.create(Pattern, attrs, action: :create)
    end

    test "create pattern with invalid pattern_type" do
      attrs = %{
        name: "Test Pattern",
        pattern_type: :invalid_type,
        cadence_code: "kick(every: 4)"
      }

      assert {:error, %Ash.Error.Invalid{}} = Ash.create(Pattern, attrs, action: :create)
    end

    test "create pattern with difficulty level out of bounds" do
      attrs = %{
        name: "Test Pattern",
        pattern_type: :melody,
        cadence_code: "scale(:C, :major)",
        difficulty_level: 11
      }

      assert {:error, %Ash.Error.Invalid{}} = Ash.create(Pattern, attrs, action: :create)
    end

    test "update pattern" do
      attrs = %{
        name: "Test Pattern",
        pattern_type: :rhythm,
        cadence_code: "kick(every: 4)"
      }

      assert {:ok, %Pattern{} = pattern} = Ash.create(Pattern, attrs, action: :create)

      assert {:ok, updated_pattern} =
               Ash.update(pattern, %{difficulty_level: 8}, action: :update)

      assert updated_pattern.difficulty_level == 8
    end

    test "read public patterns" do
      Ash.create!(Pattern, %{
        name: "Public Pattern",
        pattern_type: :rhythm,
        cadence_code: "kick()",
        is_public: true
      }, action: :create)

      Ash.create!(Pattern, %{
        name: "Private Pattern",
        pattern_type: :rhythm,
        cadence_code: "snare()",
        is_public: false
      }, action: :create)

      query = Ash.Query.for_read(Pattern, :public)
      results = Ash.read!(query)

      assert length(results) == 1
      assert hd(results).name == "Public Pattern"
    end

    test "read by pattern type" do
      Ash.create!(Pattern, %{
        name: "Rhythm Pattern",
        pattern_type: :rhythm,
        cadence_code: "kick()"
      }, action: :create)

      Ash.create!(Pattern, %{
        name: "Melody Pattern",
        pattern_type: :melody,
        cadence_code: "scale(:A, :minor)"
      }, action: :create)

      query = Ash.Query.for_read(Pattern, :by_type, %{pattern_type: :melody})
      results = Ash.read!(query)

      assert length(results) == 1
      assert hd(results).name == "Melody Pattern"
    end

    test "read by tag" do
      Ash.create!(Pattern, %{
        name: "Tag Pattern 1",
        pattern_type: :rhythm,
        cadence_code: "kick()",
        tags: ["techno", "fast"]
      }, action: :create)

      Ash.create!(Pattern, %{
        name: "Tag Pattern 2",
        pattern_type: :rhythm,
        cadence_code: "snare()",
        tags: ["house"]
      }, action: :create)

      query = Ash.Query.for_read(Pattern, :by_tag, %{tag: "techno"})
      results = Ash.read!(query)

      assert length(results) == 1
      assert hd(results).name == "Tag Pattern 1"
    end

    test "read by difficulty" do
      Ash.create!(Pattern, %{
        name: "Easy Pattern",
        pattern_type: :rhythm,
        cadence_code: "kick()",
        difficulty_level: 2
      }, action: :create)

      Ash.create!(Pattern, %{
        name: "Hard Pattern",
        pattern_type: :rhythm,
        cadence_code: "kick(every: 16)",
        difficulty_level: 9
      }, action: :create)

      query = Ash.Query.for_read(Pattern, :by_difficulty, %{min_difficulty: 1, max_difficulty: 5})
      results = Ash.read!(query)

      assert length(results) == 1
      assert hd(results).name == "Easy Pattern"
    end
  end
end
