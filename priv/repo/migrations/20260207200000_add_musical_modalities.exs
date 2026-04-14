defmodule Cantor.Repo.Migrations.AddMusicalModalities do
  use Ecto.Migration

  def change do
    # Create Scores table
    create table(:scores, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:name, :text, null: false)
      add(:notation, :map)
      add(:intent, :map)

      timestamps()
    end

    # Create Orchestras table
    create table(:orchestras, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:name, :text, null: false)
      add(:instruments, :map)
      add(:tuning, :map)
      add(:topology, :map)

      timestamps()
    end

    # Create Performances table (formerly AMF)
    create table(:performances, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:name, :text, null: false)
      add(:render_data, :map, null: false)
      add(:performance_hash, :text, null: false)

      add(:duration_seconds, :integer)
      add(:base_frequency, :float)
      add(:consciousness_state, :text)

      add(:score_id, references(:scores, type: :uuid))
      add(:orchestra_id, references(:orchestras, type: :uuid))
      add(:user_id, references(:users, type: :uuid))

      timestamps()
    end

    # Drop old AMFs table
    drop_if_exists(table(:amfs))

    # Update Compositions table
    alter table(:compositions) do
      remove(:amf_data)
      add(:performance_data, :map, default: "{}")
    end

    # Update Patterns table
    alter table(:patterns) do
      remove(:amf_signature)
      add(:performance_signature, :map, default: "{}")
    end
  end
end
