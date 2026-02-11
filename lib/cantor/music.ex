defmodule Cantor.Music do
  @moduledoc """
  The Music domain handles all music composition, pattern generation,
  and AI Music Format (AMF) operations.

  This domain contains:
  - Compositions (Scoredown documents with Cadence code)
  - Patterns (reusable musical building blocks)
  - AMF (AI Music Format JSON-LD consciousness data)
  - Collaborations (multi-user sessions)
  """

  use Ash.Domain

  resources do
    resource(Cantor.Music.Composition)
    resource(Cantor.Music.Pattern)
    resource(Cantor.Modalities.Performance)
    resource(Cantor.Modalities.Score)
    resource(Cantor.Modalities.Orchestra)
    resource(Cantor.Music.Collaboration)
    resource(Cantor.Music.CompositionPattern)
    resource(Cantor.Music.CollaborationParticipant)
  end

  authorization do
    authorize(:by_default)
  end
end
