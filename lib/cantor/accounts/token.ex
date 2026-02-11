defmodule Cantor.Accounts.Token do
  use Ash.Resource,
    domain: Cantor.Domain,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  postgres do
    table "tokens"
    repo Cantor.Repo
  end

  token do
    domain Cantor.Domain
  end
end