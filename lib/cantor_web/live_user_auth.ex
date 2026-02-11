defmodule CantorWeb.LiveUserAuth do
  @moduledoc """
  Helpers for authenticating users in LiveViews.
  """

  import Phoenix.Component
  use CantorWeb, :verified_routes

  def on_mount(:live_user_optional, _params, session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:cont, assign_current_user(socket, session)}
    end
  end

  def on_mount(:live_user_required, params, session, socket) do
    socket = assign_current_user(socket, session)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/auth/sign_in?#{[return_to: params["request_path"]]}")

      {:halt, socket}
    end
  end

  defp assign_current_user(socket, session) do
    case session do
      %{"user_token" => user_token} ->
        case AshAuthentication.subject_to_user(user_token, Cantor.Domain) do
          {:ok, user} -> assign(socket, :current_user, user)
          {:error, _} -> assign(socket, :current_user, nil)
        end

      _other ->
        assign(socket, :current_user, nil)
    end
  end
end