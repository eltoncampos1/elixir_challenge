defmodule CoreWeb.ErrorView do
  use CoreWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def translate_error(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def translate_error(reason) when is_atom(reason) do
    %{errors: %{details: Atom.to_string(reason)}}
  end

  def translate_error(reason) when is_map(reason) do
    %{errors: %{details: reason}}
  end

  def translate_error(reason) when is_bitstring(reason) do
    %{errors: %{details: reason}}
  end
end
