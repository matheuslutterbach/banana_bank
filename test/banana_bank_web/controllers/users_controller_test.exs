defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  import Mox

  alias BananaBank.Users
  alias BananaBank.Users.User

  setup do
    params = %{
      "name" => "Matheus",
      "email" => "matheus@email.com",
      "cep" => "12345678",
      "password" => "12345678"
    }

    viaCepBody = %{
      "bairro" => "",
      "cep" => "28640-000",
      "complemento" => "",
      "ddd" => "22",
      "estado" => "Rio de Janeiro",
      "gia" => "",
      "ibge" => "3301207",
      "localidade" => "Carmo",
      "logradouro" => "",
      "regiao" => "Sudeste",
      "siafi" => "5823",
      "uf" => "RJ",
      "unidade" => ""
    }

    {:ok, %{user_params: params, viaCepBody: viaCepBody}}
  end

  describe "create/2" do
    test "successfully creates an user", %{conn: conn, user_params: params, viaCepBody: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "12345678" ->
        {:ok, body}
      end)

      reponse =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "data" => %{"email" => "matheus@email.com", "name" => "Matheus", "cep" => "12345678", "id" => _id},
               "message" => "User criado com sucesso"
             } = reponse
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{
        "name" => nil,
        "email" => "matheus@email.com",
        "cep" => "12",
        "password" => "12345678"
      }

      expect(BananaBank.ViaCep.ClientMock, :call, fn "12" ->
        {:ok, ""}
      end)

      reponse =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      assert %{"errors" => %{"cep" => ["should be 8 character(s)"], "name" => ["can't be blank"]}} = reponse
    end
  end

  describe "delete/2" do
    test "successfully deletes an user", %{conn: conn, user_params: params, viaCepBody: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "12345678" ->
        {:ok, body}
      end)

      {:ok, %User{id: id}} =
        Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{id}")
        |> json_response(:ok)

      expected_response = %{
        "data" => %{"email" => "matheus@email.com", "name" => "Matheus", "cep" => "12345678", "id" => id},
        "message" => "User deletado com sucesso"
      }

      assert expected_response == response
    end
  end
end
