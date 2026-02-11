defmodule CantorWeb.PageController do
  use CantorWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
