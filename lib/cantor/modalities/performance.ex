defmodule Cantor.Modalities.Performance do
  @moduledoc """
  The Performance Modality (Programmed/Crystal): Represents the realized artifact.
  It is the result of fusing a Score (Template) with an Orchestra (Constraint/Arrangement).
  Stores the final AMF/JSON-LD data ready for execution.
  """
  use Ash.Resource,
    domain: Cantor.Music,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("performances")
    repo(Cantor.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
      description("Name of the Performance (e.g., 'Jungle Break - Liquid Mix')")
    end

    attribute :render_data, :map do
      description("The compiled AMF/JSON-LD data for the audio engine")
      allow_nil?(false)
    end

    attribute :performance_hash, :string do
      description("Unique hash of the render data for deduplication")
      allow_nil?(false)
    end

    # Metadata snapshots for quick querying
    attribute(:duration_seconds, :integer)
    attribute(:base_frequency, :float)
    attribute(:consciousness_state, :string)

    timestamps()
  end

  relationships do
    belongs_to :score, Cantor.Modalities.Score do
      description("The Score (Template) used for this performance")
      allow_nil?(false)
    end

    belongs_to :orchestra, Cantor.Modalities.Orchestra do
      description("The Orchestra (Arrangement) used for this performance")
      allow_nil?(false)
    end

    belongs_to :user, Cantor.Accounts.User do
      description("The conductor/user who initiated this performance")
    end
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      description("Create a new Performance")
      accept([:name, :render_data, :score_id, :orchestra_id, :user_id])
      change(relate_actor(:user))
    end
  end

  code_interface do
    domain(Cantor.Music)
    define(:create)
    define(:read)
    define(:destroy)
  end
end
