defmodule Cantor.Music.CompositionPattern do
  @moduledoc """
  Join table linking Compositions to Patterns they use.
  
  This allows patterns to be reused across multiple compositions
  and tracks how patterns are used within compositions.
  """
  
  use Ash.Resource,
    domain: Cantor.Music,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "composition_patterns"
    repo Cantor.Repo
  end

  attributes do
    uuid_primary_key :id
    
    attribute :usage_context, :string do
      description "Where/how this pattern is used in the composition (e.g., 'verse_drums', 'chorus_bass')"
    end
    
    attribute :parameters, :map do
      description "Pattern-specific parameters for this usage"
      default %{}
    end
    
    attribute :position_in_composition, :integer do
      description "Order/position where this pattern appears"
    end
    
    timestamps()
  end

  relationships do
    belongs_to :composition, Cantor.Music.Composition do
      primary_key? true
      allow_nil? false
    end
    
    belongs_to :pattern, Cantor.Music.Pattern do
      primary_key? true
      allow_nil? false
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  identities do
    identity :unique_composition_pattern, [:composition_id, :pattern_id]
  end
end