defmodule BananaBankWeb.Token do
  alias Phoenix.Token
  alias BananaBankWeb.Endpoint

  @salt_salt "banana_bank_api"

  def sign(user) do
    Token.sign(Endpoint, @salt_salt, %{user_id: user.id})
  end

  def verify(token), do: Token.verify(Endpoint, @salt_salt, token, max_age: 86400)
end
