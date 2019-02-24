defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts Context.
  """

  alias Rumbl.Repo
  alias Rumbl.Accounts.User
  import Ecto.Query

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_email(email) do
    from(u in User, join: c in assoc(u, :credential), where: c.email == ^email)
    |> Repo.one()
    |> Repo.preload(:credential)
  end

  def authenticate_by_email_and_pass(email, pass) do
    user = get_user_by_email(email)

    cond do
      user && Comeonin.Pbkdf2.checkpw(pass, user.credential.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        Comeonin.Pbkdf2.dummy_checkpw()
        {:error, :not_found}
    end
  end
end
