defmodule SketchWeb.Validations.Api.CanvasValidation.Create do

    @moduledoc """
      API validation module for creating canvas
    """

    use Ecto.Schema
    import Ecto.Changeset
  
    @all_attributes [
      :width,
      :height
    ]

    @required_attributes [
        :width,
        :height
      ]
  
    schema "canvas_validation" do
      field(:width, :integer)
      field(:height, :integer)
    end
  
    @doc false
    def changeset(struct, attrs) do
      struct
      |> cast(attrs, @all_attributes)
      |> validate_required(@required_attributes)
    end
  end
  