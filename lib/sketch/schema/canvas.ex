defmodule Sketch.Schema.Canvas do
    use Ecto.Schema
    import Ecto.Changeset
    
    @behaviour Bodyguard.Schema
    @primary_key {:id, :binary_id, autogenerate: true}
  
    @all_attributes [
      :type,
      :meta_data,
      :matrix
    ]

    schema "canvas" do
      field(:type, :string)
      field(:meta_data, :map)
      field(:matrix, :map)
    end
  
    @doc false
    def changeset(%__MODULE__{} = canvas, params) do
      canvas
      |> cast(params, @all_attributes)
    end
  end
  