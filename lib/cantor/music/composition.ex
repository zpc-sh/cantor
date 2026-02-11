defmodule Cantor.Music.Composition do
  @moduledoc """
  A Composition represents a complete musical work in Scoredown format.

  It contains:
  - Markdown-LD content with embedded Cadence code and JSON-LD
  - Compiled JSON-LD graph of the entire composition
  - AI Music Format (AMF) data for AI consciousness
  - Consciousness parameters (frequency, optimization level)
  """

  use Ash.Resource,
    domain: Cantor.Music,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table("compositions")
    repo(Cantor.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :title, :string do
      allow_nil?(false)
      description("Human-readable title of the composition")
    end

    attribute :scoredown_content, :string do
      description("Full Scoredown (Markdown-LD) content with Cadence code blocks and JSON-LD")
    end

    attribute :jsonld_graph, :map do
      description("Compiled JSON-LD graph from all embedded JSON-LD blocks")
      default(%{})
    end

    attribute :performance_data, :map do
      description("The materialized Performance data (formerly AMF)")
      default(%{})
    end

    attribute :consciousness_params, :map do
      description("Consciousness optimization parameters")

      default(%{
        "base_frequency" => 7.5,
        "optimization" => "balanced",
        "grounding" => true
      })
    end

    attribute :is_public, :boolean do
      default(false)
      description("Whether this composition is publicly visible")
    end

    attribute :tags, {:array, :string} do
      default([])
      description("Genre, style, and other categorization tags")
    end

    timestamps()
  end

  relationships do
    belongs_to :user, Cantor.Accounts.User do
      description("The user who created this composition")
    end

    has_many :patterns, Cantor.Music.Pattern do
      description("Reusable patterns extracted from this composition")
    end

    has_many :performances, Cantor.Modalities.Performance do
      description("Realized performances of this composition")
    end

    has_many :collaborations, Cantor.Music.Collaboration do
      description("Collaborative editing sessions for this composition")
    end
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      description("Create a new composition")
      accept([:title, :scoredown_content, :consciousness_params, :is_public, :tags])

      change(relate_actor(:user))
    end

    update :update do
      description("Update composition content and recompile")
      accept([:title, :scoredown_content, :consciousness_params, :is_public, :tags])
    end

    read :public do
      description("Read public compositions")
      filter(expr(is_public == true))
    end

    read :by_user do
      description("Read compositions by a specific user")
      argument(:user_id, :uuid, allow_nil?: false)
      filter(expr(user_id == ^arg(:user_id)))
    end

    read :by_tag do
      description("Find compositions with specific tags")
      argument(:tag, :string, allow_nil?: false)
      filter(expr(^arg(:tag) in tags))
    end
  end

  policies do
    # Users can read their own compositions
    policy action_type(:read) do
      authorize_if(actor_attribute_equals(:id, :user_id))
    end

    # Anyone can read public compositions
    policy action(:public) do
      authorize_if(always())
    end

    # Users can create compositions
    policy action_type(:create) do
      authorize_if(actor_present())
    end

    # Users can only update/delete their own compositions
    policy action_type([:update, :destroy]) do
      authorize_if(actor_attribute_equals(:id, :user_id))
    end
  end

  identities do
    identity(:unique_title_per_user, [:user_id, :title])
  end

  preparations do
    prepare(build(load: [:user, :patterns, :performances]))
  end
end
