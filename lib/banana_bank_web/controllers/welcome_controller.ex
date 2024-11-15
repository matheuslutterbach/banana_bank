defmodule BananaBankWeb.WelcomeController do
  use BananaBankWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{message: "Bem vindo ao Banana Bank", status: :ok})

    conn
  end
end
