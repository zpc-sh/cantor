defmodule Cantor.Music.Pattern do
  @moduledoc """
  A Pattern represents a reusable musical building block that can be
  shared between compositions.

  Patterns can be:
  - Rhythm patterns (kick, snare, hihat sequences)
  - Melodic patterns (note sequences, scales)
  - Harmonic patterns (chord progressions)
  - Effect chains (reverb + delay combinations)
  - Consciousness patterns (optimization sequences)
  """

  use Ash.Resource,
    domain: Cantor.Music,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table("patterns")
    repo(Cantor.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
      description("Human-readable name for this pattern")
    end

    attribute :pattern_type, :atom do
      constraints(one_of: [:rhythm, :melody, :harmony, :effect, :consciousness, :composite])
      allow_nil?(false)
      description("Type of musical pattern")
    end

    attribute :cadence_code, :string do
      description("The Cadence language code that defines this pattern")
      allow_nil?(false)
    end

    attribute :performance_signature, :map do
      description("Performance (AMF) signature for this pattern")
      default(%{})
    end

    attribute :parameters, :map do
      description("Configurable parameters for this pattern")
      default(%{})
    end

    attribute :tags, {:array, :string} do
      default([])
      description("Genre, style, instrument tags")
    end

    attribute :is_public, :boolean do
      default(false)
      description("Whether this pattern can be used by other users")
    end

    attribute :difficulty_level, :integer do
      constraints(min: 1, max: 10)
      default(5)
      description("Complexity level from 1 (simple) to 10 (advanced)")
    end

    attribute :bpm_range, :map do
      description("Recommended BPM range for this pattern")
      default(%{"min" => 60, "max" => 200})
    end

    timestamps()
  end

  relationships do
    belongs_to :user, Cantor.Accounts.User do
      description("The user who created this pattern")
    end

    belongs_to :composition, Cantor.Music.Composition do
      description("The composition this pattern was extracted from (if any)")
      allow_nil?(true)
    end

    many_to_many :used_in_compositions, Cantor.Music.Composition do
      through(Cantor.Music.CompositionPattern)
      source_attribute_on_join_resource(:pattern_id)
      destination_attribute_on_join_resource(:composition_id)
      description("Compositions that use this pattern")
    end
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      description("Create a new pattern")

      accept([
        :name,
        :pattern_type,
        :cadence_code,
        :parameters,
        :tags,
        :is_public,
        :difficulty_level,
        :bpm_range
      ])

      change(relate_actor(:user))
    end

    update :update do
      description("Update pattern and recompile")

      accept([
        :name,
        :pattern_type,
        :cadence_code,
        :parameters,
        :tags,
        :is_public,
        :difficulty_level,
        :bpm_range
      ])
    end

    read :public do
      description("Read public patterns")
      filter(expr(is_public == true))
    end

    read :by_type do
      description("Find patterns by type")
      argument(:pattern_type, :atom, allow_nil?: false)
      filter(expr(pattern_type == ^arg(:pattern_type)))
    end

    read :by_tag do
      description("Find patterns with specific tags")
      argument(:tag, :string, allow_nil?: false)
      filter(expr(^arg(:tag) in tags))
    end

    read :by_difficulty do
      description("Find patterns within difficulty range")
      argument(:min_difficulty, :integer, allow_nil?: false)
      argument(:max_difficulty, :integer, allow_nil?: false)

      filter(
        expr(
          difficulty_level >= ^arg(:min_difficulty) and difficulty_level <= ^arg(:max_difficulty)
        )
      )
    end

    read :by_bpm do
      description("Find patterns suitable for a specific BPM")
      argument(:bpm, :integer, allow_nil?: false)
      # This would need a custom filter function to check if BPM falls within the range
    end
  end

  policies do
    # Users can read their own patterns
    policy action_type(:read) do
      authorize_if(actor_attribute_equals(:id, :user_id))
    end

    # Anyone can read public patterns
    policy action(:public) do
      authorize_if(always())
    end

    # Users can create patterns
    policy action_type(:create) do
      authorize_if(actor_present())
    end

    # Users can only update/delete their own patterns
    policy action_type([:update, :destroy]) do
      authorize_if(actor_attribute_equals(:id, :user_id))
    end
  end

  identities do
    identity(:unique_name_per_user, [:user_id, :name])
  end

  preparations do
    prepare(build(load: [:user, :composition]))
  end
end
