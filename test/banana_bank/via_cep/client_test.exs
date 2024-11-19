defmodule BananaBank.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias BananaBank.ViaCep.Client

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "successfully returns cep info", %{bypass: bypass} do
      cep = "28640000"

      body = ~s({
        "cep":"28640-000",
        "logradouro":"",
        "complemento":"",
        "unidade":"",
        "bairro":"",
        "localidade":"Carmo",
        "uf":"RJ",
        "estado":"Rio de Janeiro",
        "regiao":"Sudeste",
        "ibge":"3301207",
        "gia":"",
        "ddd":"22",
        "siafi":"5823"
      })

      expected_response =
        {:ok,
         %{
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
         }}

      Bypass.expect(bypass, "GET", "/#{cep}/json", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body)
      end)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(cep)

      assert response == expected_response
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
