defmodule Cantor.Accounts.User do
  use Ash.Resource,
    domain: Cantor.Domain,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  postgres do
    table("users")
    repo(Cantor.Repo)
  end

  authentication do
    strategies do
      password :password do
        identity_field(:email)
        hashed_password_field(:hashed_password)
        hash_provider(AshAuthentication.BcryptProvider)
        confirmation_required?(false)
      end

      magic_link :magic_link do
        identity_field(:email)
        token_lifetime({10, :minutes})
        request_action_name(:request_magic_link)
        single_use_token?(true)

        sender(fn user, token, _opts ->
          # For now, just log the token. In production, you'd send an email
          IO.puts("Magic link token for #{user.email}: #{token}")
          :ok
        end)
      end
    end

    tokens do
      enabled?(true)
      token_resource(Cantor.Accounts.Token)
      signing_secret(&get_config/2)
      require_token_presence_for_authentication?(true)
    end

    session_identifier(:jti)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :email, :ci_string do
      allow_nil?(false)
      public?(true)
    end

    attribute :hashed_password, :string do
      allow_nil?(true)
      sensitive?(true)
    end

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end

  identities do
    identity(:unique_email, [:email])
  end

  actions do
    defaults([:create, :read, :update, :destroy])

    read :by_email do
      argument(:email, :ci_string, allow_nil?: false)
      get?(true)
      filter(expr(email == ^arg(:email)))
    end
  end

  defp get_config(path, _resource) do
    value =
      Application.get_env(:cantor, path) ||
        raise "Please configure #{inspect(path)} in your runtime config"

    {:ok, value}
  end
end
