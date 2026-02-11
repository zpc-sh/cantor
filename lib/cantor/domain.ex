defmodule Cantor.Domain do
  use Ash.Domain

  resources do
    resource Cantor.Accounts.User
    resource Cantor.Accounts.Token
    
    # Music Domain Resources
    resource Cantor.Music.Composition
    resource Cantor.Music.Pattern
    resource Cantor.Music.AMF
    resource Cantor.Music.Collaboration
    resource Cantor.Music.CompositionPattern
    resource Cantor.Music.CollaborationParticipant
  end

  authorization do
    authorize :by_default
  end
end