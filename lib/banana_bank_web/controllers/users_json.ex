defmodule BananaBankWeb.UsersJSON do
  alias BananaBank.Users.User

  def created(%{user: user}) do
    %{
      message: "User criado com sucesso",
      data: data(user)
    }
  end

  def get(%{user: user}), do: %{data: data(user)}

  def update(%{user: user}) do
    %{
      message: "User atualizado com sucesso",
      data: data(user)
    }
  end

  def delete(%{user: user}) do
    %{
      message: "User deletado com sucesso",
      data: data(user)
    }
  end

  def login(%{token: token}) do
    %{
      message: "User autenticado com sucesso",
      bearer: token
    }
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      cep: user.cep,
      email: user.email,
      name: user.name
    }
  end
end
