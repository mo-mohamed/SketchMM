defmodule SketchWeb.Api.ErrorView do
    use SketchWeb, :view
  
    def render("401.json", %{msg: _msg}) do
      "Unauthorized"
    end
  
    def render("403.json", %{msg: _msg}) do
      "Forbidden"
    end
  
    def render("404.json", %{msg: _msg}) do
      "Not Found"
    end
  
    def render("error.json", %{errors: errors}) do
      %{errors: errors}
    end
  
    def render("error.json", %{changeset: changeset}) do
      # When encoded, the changeset returns its errors
      # as a JSON object. So we just pass it forward.
      %{errors: translate_errors(changeset)}
    end
  
    defp translate_errors(changeset) do
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", translate_error_opt_value(value))
        end)
      end)
    end
  
    defp translate_error_opt_value(value) when is_tuple(value) do
      Enum.join(Tuple.to_list(value), ", ")
    end
  
    defp translate_error_opt_value(value) when is_list(value) do
      Enum.join(value, ", ")
    end
  
    defp translate_error_opt_value(value) do
      to_string(value)
    end
  
    def status_message(status_atom) when is_atom(status_atom) do
      status_text =
        status_atom
        |> Plug.Conn.Status.code()
        |> Plug.Conn.Status.reason_phrase()
  
      %{status: status_text}
    end
  
    def status_message(status) do
      status
    end
  end
  