defmodule CoreWeb.AddressView do
  use CoreWeb, :view

  def render("new.json", %{address: address}) do
    %{
      id: address.id,
      cep: address.cep,
      state: address.state,
      city: address.city,
      number: address.number
    }
  end
end
