defmodule Cantor.Modalities.Score do
  @moduledoc """
  The Score Modality (Template): Represents WHAT is played.
  Stores the "Sheet Music" or Pattern Templates.
  """
  use Ash.Resource,
    domain: Cantor.Music,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("scores")
    repo(Cantor.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
      description("Name of the Score/Template (e.g., 'Jungle Break')")
    end

    attribute :notation, :map do
      description("The raw pattern data or Cadence AST")
      default(%{})
    end

    attribute :intent, :map do
      description("Semantic intent metadata (e.g., emotion: 'Manic', complexity: 'High')")
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
