defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias BananaBank.Accounts.Account

  @requerid_params_create [:name, :password, :email, :cep]
  @requerid_params_update [:name, :email, :cep]

  schema "users" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :email, :string
    field :cep, :string
    has_one :account, Account

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @requerid_params_create)
    |> do_validations(@requerid_params_create)
    |> add_password_hash()
  end

  def changeset(user, params) do
    user
    |> cast(params, @requerid_params_update)
    |> do_validations(@requerid_params_create)
    |> add_password_hash()
  end

  defp do_validations(changeset, fields) do
    changeset
    |> validate_required(fields)
    |> validate_length(:name, min: 3)
    |> validate_length(:cep, is: 8)
    |> validate_length(:password, min: 6)
  end

  def add_password_hash(
        %Changeset{valid?: true, changes: %{password: password}} =
          changeset
      ) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  def add_password_hash(changeset), do: changeset
end
