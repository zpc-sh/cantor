# Cantor Ash Authentication Guide for AI Agents

## Overview

The Cantor platform uses **Ash Authentication** with Phoenix for user management and session handling. This guide ensures all AI agents implementing features understand the existing authentication system and use the correct resources.

---

## 🚨 CRITICAL: Use Existing Resources

**DO NOT** create new authentication resources. We already have:

- **User Resource**: `Cantor.Accounts.User` 
- **Token Resource**: `Cantor.Accounts.Token`
- **Domain**: `Cantor.Domain` 
- **Authentication Controller**: `CantorWeb.AuthController`
- **LiveView Auth Helper**: `CantorWeb.LiveUserAuth`

---

## Current Authentication Setup

### 1. User Resource (`lib/cantor/accounts/user.ex`)

```elixir
defmodule Cantor.Accounts.User do
  use Ash.Resource,
    domain: Cantor.Domain,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  # Authentication strategies:
  # - Password (email/password login)  
  # - Magic Link (passwordless login)
  
  # Key attributes:
  # - :id (uuid_primary_key)
  # - :email (ci_string, unique)
  # - :hashed_password (string, sensitive)
  
  # Session management with JWT tokens
end
```

### 2. Token Resource (`lib/cantor/accounts/token.ex`)

```elixir
defmodule Cantor.Accounts.Token do
  use Ash.Resource,
    domain: Cantor.Domain,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]
    
  # Handles JWT tokens for session management
  # Used by AshAuthentication automatically
end
```

### 3. Domain Configuration

```elixir
defmodule Cantor.Domain do
  use Ash.Domain

  resources do
    resource Cantor.Accounts.User
    resource Cantor.Accounts.Token
    # Add your new resources here, NOT new auth resources
  end

  authorization do
    authorize :by_default
  end
end
```

---

## Authentication Patterns for New Features

### ✅ Correct: Reference Existing User

```elixir
defmodule Cantor.Music.Composition do
  use Ash.Resource,
    domain: Cantor.Domain,
    data_layer: AshPostgres.DataLayer

  relationships do
    belongs_to :user, Cantor.Accounts.User  # ✅ Use existing User
  end
  
  actions do
    create :create do
      change relate_actor(:user)  # ✅ Auto-relate to current user
    end
  end
end
```

### ❌ Wrong: Creating New Auth Resources

```elixir
# DON'T DO THIS
defmodule Cantor.Music.MusicUser do
  use Ash.Resource, extensions: [AshAuthentication]  # ❌ NO!
end
```

---

## Session Management in LiveViews

### Use Existing LiveUserAuth

```elixir
defmodule CantorWeb.NotebookLive do
  use CantorWeb, :live_view
  
  # In router.ex, sessions are already configured:
  live_session :authentication_required,
    on_mount: {CantorWeb.LiveUserAuth, :live_user_required} do
    live "/notebook/:id", NotebookLive
  end
  
  def mount(_params, _session, socket) do
    # socket.assigns.current_user is available automatically
    user = socket.assigns.current_user
    {:ok, socket}
  end
end
```

---

## Database Queries with User Context

### ✅ Correct: Use actor context

```elixir
# Get user's compositions
compositions = Cantor.Music.Composition
|> Ash.Query.for_read(:read)
|> Ash.read!(actor: current_user)

# Create composition for user  
Cantor.Music.Composition
|> Ash.Changeset.for_create(:create, %{title: "My Song"})
|> Ash.create!(actor: current_user)
```

### ❌ Wrong: Manual user filtering

```elixir
# Don't do manual user_id filtering
compositions = Cantor.Music.Composition
|> Ash.Query.filter(user_id == ^user.id)  # ❌ Use actor instead
```

---

## Routes Configuration

### Existing Auth Routes (DO NOT MODIFY)

```elixir
# In router.ex - these exist:
scope "/auth" do
  pipe_through :browser
  
  auth_routes CantorWeb.AuthController, Cantor.Accounts.User
  sign_out_route CantorWeb.AuthController
end

# Available routes:
# GET/POST /auth/sign_in
# GET/POST /auth/register  
# POST /auth/sign_out
# GET/POST /auth/magic_link
```

### ✅ Adding New Protected Routes

```elixir
scope "/", CantorWeb do
  pipe_through :browser

  live_session :authentication_required,
    on_mount: {CantorWeb.LiveUserAuth, :live_user_required} do
    
    live "/compositions", CompositionIndexLive
    live "/notebook/:id", NotebookLive
    # Add your new protected routes here
  end
end
```

---

## API/JSON Authentication

### For API endpoints, use existing token auth:

```elixir
# In API pipeline
pipeline :api do
  plug :accepts, ["json"]
  plug AshAuthentication.Plug  # Already configured
end

scope "/api", CantorWeb do  
  pipe_through :api
  
  # Your API routes here - current_user available via conn.assigns
end
```

---

## Common Patterns

### 1. Check if user is logged in (LiveView)

```elixir
def mount(_params, _session, socket) do
  if socket.assigns.current_user do
    # User is logged in
    {:ok, socket}
  else
    # Redirect to login (or handle guest access)
    {:ok, redirect(socket, to: ~p"/auth/sign_in")}
  end
end
```

### 2. User-specific actions

```elixir
def handle_event("create_composition", params, socket) do
  user = socket.assigns.current_user
  
  result = Cantor.Music.Composition
  |> Ash.Changeset.for_create(:create, params)
  |> Ash.create(actor: user)  # ✅ Pass user as actor
  
  case result do
    {:ok, composition} -> # handle success
    {:error, changeset} -> # handle error  
  end
end
```

### 3. Authorization policies (in resources)

```elixir
policies do
  # Only users can read their own compositions
  policy action_type(:read) do
    authorize_if actor_attribute_equals(:id, :user_id)
  end
  
  # Only users can create compositions
  policy action_type(:create) do
    authorize_if actor_present()
  end
end
```

---

## Configuration References

### Current config (DO NOT CHANGE):

```elixir
# config/runtime.exs
config :cantor, :token_signing_secret, System.get_env("TOKEN_SIGNING_SECRET") || "dev-secret"

# lib/cantor/application.ex  
{AshAuthentication.Supervisor, otp_app: :cantor},
```

---

## Testing Authentication

### Test with authenticated user:

```elixir
test "creates composition for user" do
  user = 
    Cantor.Accounts.User
    |> Ash.Changeset.for_create(:register, %{
      email: "test@example.com", 
      password: "password123"
    })
    |> Ash.create!()
    
  composition =
    Cantor.Music.Composition  
    |> Ash.Changeset.for_create(:create, %{title: "Test Song"})
    |> Ash.create!(actor: user)
    
  assert composition.user_id == user.id
end
```

---

## 🎯 Key Takeaways for Agents

1. **NEVER create new auth resources** - use `Cantor.Accounts.User`
2. **Always use `actor: current_user`** in Ash operations  
3. **Use existing LiveUserAuth** for LiveView authentication
4. **Reference User in relationships** via `belongs_to :user, Cantor.Accounts.User`
5. **Add to existing Domain** - don't create new domains for auth

---

## Need Help?

- Check existing User resource: `lib/cantor/accounts/user.ex`
- Look at router config: `lib/cantor_web/router.ex`  
- See LiveUserAuth helper: `lib/cantor_web/live_user_auth.ex`
- Review auth controller: `lib/cantor_web/auth_controller.ex`

**When in doubt, follow existing patterns. Authentication is already working!**

---

## 🔥 MANDATORY: TEST YOUR CHANGES

### After making ANY changes to files, you MUST:

1. **Compile the project** to check for errors:
   ```bash
   cd ~/src/code/cantor && mix compile
   ```

2. **If compilation fails**, fix the errors immediately - DON'T just write code and leave

3. **For new migrations**, generate and run them:
   ```bash
   # Generate migrations from Ash resources
   mix ash_postgres.generate_migrations
   
   # Then run the migrations
   mix ecto.migrate
   ```

4. **For new dependencies**, install them:
   ```bash
   mix deps.get
   ```

### ⚠️ ZERO TOLERANCE for broken builds

- **If you introduce syntax errors, YOU fix them**
- **If you break existing functionality, YOU fix it** 
- **Don't write code and run off - ensure it compiles**
- **Test your changes actually work**

### Example workflow:
```bash
# 1. Make your changes to files
# 2. Always test compilation
mix compile

# 3. If errors, fix them immediately:
# == Compilation error in file lib/cantor/music/composition.ex ==
# ** (CompileError) lib/cantor/music/composition.ex:25: undefined function belongs_to/2
# Fix: use belongs_to from Ash.Resource

# 4. Ensure it compiles cleanly before moving on
mix compile
# Compiling 1 file (.ex)
# ✅ Success!

# 5. Generate migrations for new Ash resources
mix ash_postgres.generate_migrations migration_name

# 6. Run the migrations
mix ecto.migrate

# 7. Test the actual functionality if possible
mix test test/cantor/music/composition_test.exs
```

**No agent should leave the codebase in a broken state. EVER.**