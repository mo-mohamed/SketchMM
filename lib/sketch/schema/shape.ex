defmodule Sketch.Schema.Shape do
    use Ecto.Schema
    import Ecto.Changeset
    
    @behaviour Bodyguard.Schema
    @primary_key {:id, :binary_id, autogenerate: true}
  
    @all_attributes [
      :type,
      :meta_data,
      :canvas_id
    ]

    schema "shape" do
      field(:type, :string)
      field(:meta_data, :map)
      belongs_to(:canvas, Sketch.Schema.Canvas, type: :binary_id)
    end
  
    @doc false
    def changeset(%__MODULE__{} = canvas, params) do
      canvas
      |> cast(params, @all_attributes)
    end
  end
  