defmodule Cantor.Music.Collaboration do
  @moduledoc """
  A Collaboration represents a real-time collaborative editing session
  for a composition between multiple users (humans and AIs).
  
  Features:
  - Real-time multi-user editing via Phoenix LiveView
  - AI agents can join as participants
  - Operational Transform for conflict resolution
  - Session consciousness synchronization
  - Change tracking and version history
  """
  
  use Ash.Resource,
    domain: Cantor.Music,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "collaborations"
    repo Cantor.Repo
  end

  attributes do
    uuid_primary_key :id
    
    attribute :name, :string do
      allow_nil? false
      description "Name for this collaboration session"
    end
    
    attribute :status, :atom do
      constraints one_of: [:active, :paused, :completed, :archived]
      default :active
      description "Current status of the collaboration"
    end
    
    attribute :collaboration_type, :atom do
      constraints one_of: [:human_only, :ai_assisted, :ai_collaborative, :mixed]
      default :human_only
      description "Type of collaboration participants"
    end
    
    attribute :shared_consciousness, :map do
      description "Synchronized consciousness parameters for all participants"
      default %{
        "base_frequency" => 7.5,
        "sync_coefficient" => 0.85,
        "coherence_target" => 0.9
      }
    end
    
    attribute :operational_transform_log, {:array, :map} do
      description "Log of operational transforms for conflict resolution"
      default []
    end
    
    attribute :participant_cursors, :map do
      description "Current cursor positions of all participants"
      default %{}
    end
    
    attribute :session_metadata, :map do
      description "Session-specific data (tempo, key, mode, etc.)"
      default %{}
    end
    
    attribute :ai_participants, {:array, :string} do
      description "List of AI agent identifiers in this session"
      default []
    end
    
    attribute :max_participants, :integer do
      default 10
      description "Maximum number of participants allowed"
    end
    
    attribute :is_public, :boolean do
      default false
      description "Whether others can join this collaboration"
    end
    
    attribute :last_activity_at, :utc_datetime do
      description "Timestamp of last collaborative activity"
    end
    
    timestamps()
  end

  relationships do
    belongs_to :composition, Cantor.Music.Composition do
      description "The composition being collaborated on"
    end
    
    belongs_to :owner, Cantor.Accounts.User do
      description "The user who started this collaboration"
    end
    
    many_to_many :participants, Cantor.Accounts.User do
      through Cantor.Music.CollaborationParticipant
      source_attribute_on_join_resource :collaboration_id
      destination_attribute_on_join_resource :user_id
      description "Human participants in this collaboration"
    end
  end

  actions do
    defaults [:read, :destroy]
    
    create :create do
      description "Start a new collaboration session"
      accept [:name, :collaboration_type, :shared_consciousness, :session_metadata, :max_participants, :is_public]
      argument :composition_id, :uuid, allow_nil?: false
      
      change relate_actor(:owner)
      change manage_relationship(:composition_id, :composition, type: :append_and_remove)
    end
    
    update :update do
      description "Update collaboration settings"
      accept [:name, :status, :shared_consciousness, :session_metadata, :max_participants, :is_public]
      
    end
    
    update :add_participant do
      description "Add a participant to the collaboration"
      argument :user_id, :uuid, allow_nil?: false
      
      change manage_relationship(:user_id, :participants, type: :append)
    end
    
    update :remove_participant do
      description "Remove a participant from the collaboration"
      argument :user_id, :uuid, allow_nil?: false
      
      change manage_relationship(:user_id, :participants, type: :remove)
    end
    
    update :add_ai_participant do
      description "Add an AI agent to the collaboration"
      argument :ai_id, :string, allow_nil?: false
      
    end
    
    update :apply_transform do
      description "Apply an operational transform"
      argument :transform, :map, allow_nil?: false
      argument :participant_id, :string, allow_nil?: false
      
    end
    
    update :sync_consciousness do
      description "Synchronize consciousness parameters across participants"
      accept [:shared_consciousness]
      
    end
    
    read :active do
      description "Get active collaborations"
      filter expr(status == :active)
    end
    
    read :by_composition do
      description "Get collaborations for a specific composition"
      argument :composition_id, :uuid, allow_nil?: false
      filter expr(composition_id == ^arg(:composition_id))
    end
    
    read :public do
      description "Get public collaborations others can join"
      filter expr(is_public == true and status == :active)
    end
    
    read :for_user do
      description "Get collaborations a user owns or participates in"
      argument :user_id, :uuid, allow_nil?: false
      # This needs a custom filter to check both owner and participants
    end
  end

  policies do
    # Owners can read their collaborations
    policy action_type(:read) do
      authorize_if actor_attribute_equals(:id, :owner_id)
    end
    
    # Participants can read collaborations they're part of
    policy action_type(:read) do
      authorize_if relates_to_actor_via(:participants)
    end
    
    # Anyone can read public active collaborations
    policy action(:public) do
      authorize_if always()
    end
    
    # Users can create collaborations
    policy action_type(:create) do
      authorize_if actor_present()
    end
    
    # Only owners can update collaboration settings
    policy action_type([:update, :destroy]) do
      authorize_if actor_attribute_equals(:id, :owner_id)
    end
    
    # Participants can apply transforms
    policy action(:apply_transform) do
      authorize_if relates_to_actor_via(:participants)
    end
  end

  preparations do
    prepare build(load: [:composition, :owner, :participants])
  end
end