defmodule Cantor.Modalities.Orchestra do
  @moduledoc """
  The Orchestra Modality (Proof): Represents WHO plays it and HOW.
  Stores the "Arrangement", Constraints, and Instrument Definitions.
  """
  use Ash.Resource,
    domain: Cantor.Music,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("orchestras")
    repo(Cantor.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
      description("Name of the Orchestra/Constraint (e.g., 'Liquid DnB Ensemble')")
    end

    attribute :instruments, :map do
      description("Definitions of available instruments and their parameters")
      default(%{})
    end

    attribute :tuning, :map do
      description(
        "Global tuning and harmonic constraints (e.g., {fundamental: 432, scale: :minor})"
      )

      default(%{})
    end

    attribute :topology, :map do
      description("Allowable state transitions and consciousness constraints")
      default(%{})
    end

    timestamps()
  end

  actions do
    defaults([:read, :destroy, create: :*, update: :*])
  end

  code_interface do
    domain(Cantor.Music)
    define(:create)
    define(:read)
    define(:update)
    define(:destroy)
  end
end
