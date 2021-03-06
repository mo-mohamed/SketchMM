defmodule SketchWeb.Validations.Api.CanvasValidation.FloodFill.Create do


    @moduledoc """
      API validation module for flood fill requests paramaters
    """

    use Ecto.Schema
    import Ecto.Changeset
  
    @all_attributes [
      :x_coordinate,
      :y_coordinate,
      :filling
    ]

    @required_attributes [
      :x_coordinate,
      :y_coordinate,
      :filling
    ]
  
    schema "flood_fill_validation" do
      field(:x_coordinate, :integer)
      field(:y_coordinate, :integer)
      field(:filling, :string)
    end
  
    @doc false
    def changeset(struct, attrs) do
      struct
      |> cast(attrs, @all_attributes)
      |> validate_required(@required_attributes)
    end
  end
  