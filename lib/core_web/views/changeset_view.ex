defmodule CoreWeb.ChangesetView do
  use CoreWeb, :view

  def render("error.json", %{changeset: changeset}) do
    %{
      status: "failure",
      errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    }
  end
end
