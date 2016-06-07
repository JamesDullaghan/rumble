defmodule Rumble.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller
  alias Rumble.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(Rumble.User, user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def login_by_username_and_pass(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Rumble.User, username: username)

    cond do
      # user exists and password matches
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      # user exists but no matching password
      user ->
        {:error, :unauthorized, conn}
      # if no user is found, dummy pw check to help protect against timing attacks
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    # drop: true drops the whole session at the end of the request
    # If you want to keep the session around, you can delete only the user ID information
    # delete_session(conn, :user_id)
    configure_session(conn, drop: true)
  end

  # function plug
  # a function plug is a function that receives 2 arguments
  # the connection and a set of options
  # the plug must return the connection
  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end
end
