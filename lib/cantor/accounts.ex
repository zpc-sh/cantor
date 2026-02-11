defmodule Cantor.Accounts do
  @moduledoc """
  The Accounts domain handles user authentication, registration, and 
  session management for the Cantor platform.
  
  This domain contains:
  - Users (with email/password and magic link authentication)
  - Tokens (for JWT session management)
  """
  
  use Ash.Domain

  resources do
    resource Cantor.Accounts.User
    resource Cantor.Accounts.Token
  end

  authorization do
    authorize :by_default
  end
end