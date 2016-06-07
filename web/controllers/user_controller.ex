defmodule Rumble.UserController do
  use Rumble.Web, :controller
  alias Rumble.User
  plug :authenticate when action in [:index, :show]

  def index(conn, _params) do
    users = Repo.all(Rumble.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Rumble.User, id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset  = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Rumble.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # function plug
  # a function plug is a function that receives 2 arguments
  # the connection and a set of options
  # the plug must return the connection
  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
