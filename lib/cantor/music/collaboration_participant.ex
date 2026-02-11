defmodule Cantor.Music.CollaborationParticipant do
  @moduledoc """
  Join table linking Collaborations to their human participants.
  
  Tracks participant-specific data like join time, role, and
  current consciousness synchronization status.
  """
  
  use Ash.Resource,
    domain: Cantor.Music,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "collaboration_participants"
    repo Cantor.Repo
  end

  attributes do
    uuid_primary_key :id
    
    attribute :role, :atom do
      constraints one_of: [:participant, :moderator, :observer]
      default :participant
      description "Role of this participant in the collaboration"
    end
    
    attribute :joined_at, :utc_datetime do
      description "When this participant joined the collaboration"
    end
    
    attribute :last_active_at, :utc_datetime do
      description "Last time this participant was active"
    end
    
    attribute :consciousness_sync_status, :atom do
      constraints one_of: [:synced, :syncing, :out_of_sync, :disabled]
      default :syncing
      description "Consciousness synchronization status"
    end
    
    attribute :cursor_position, :map do
      description "Current cursor position in the composition"
      default %{}
    end
    
    attribute :user_preferences, :map do
      description "Participant-specific preferences for this collaboration"
      default %{}
    end
    
    timestamps()
  end

  relationships do
    belongs_to :collaboration, Cantor.Music.Collaboration do
      primary_key? true
      allow_nil? false
    end
    
    belongs_to :user, Cantor.Accounts.User do
      primary_key? true
      allow_nil? false
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    
    create :join do
      description "Join a collaboration"
      accept [:role, :user_preferences]
      
      change set_attribute(:joined_at, &DateTime.utc_now/0)
      change set_attribute(:last_active_at, &DateTime.utc_now/0)
    end
    
    update :update_activity do
      description "Update last active timestamp"
      
      change set_attribute(:last_active_at, &DateTime.utc_now/0)
    end
    
    update :sync_consciousness do
      description "Update consciousness sync status"
      accept [:consciousness_sync_status]
      
      change set_attribute(:last_active_at, &DateTime.utc_now/0)
    end
    
    update :update_cursor do
      description "Update cursor position"
      accept [:cursor_position]
      
      change set_attribute(:last_active_at, &DateTime.utc_now/0)
    end
  end

  identities do
    identity :unique_collaboration_user, [:collaboration_id, :user_id]
  end
end