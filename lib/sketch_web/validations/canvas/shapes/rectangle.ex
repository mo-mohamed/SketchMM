defmodule SketchWeb.Validations.Api.CanvasValidation.Rectangle.Create do

    @moduledoc """
      API validation module for rectangles requests paramaters
    """

    use Ecto.Schema
    import Ecto.Changeset
  
    @all_attributes [
      :width,
      :height,
      :x_coordinate,
      :y_coordinate,
      :inner_filling,
      :border_filling
    ]

    @required_attributes [
        :width,
        :height,
        :x_coordinate,
        :y_coordinate
      ]
  
    schema "rectangle_validation" do
      field(:width, :integer)
      field(:height, :integer)
      field(:x_coordinate, :integer)
      field(:y_coordinate, :integer)
      field(:inner_filling, :string)
      field(:border_filling, :string)
    end
  
    @doc false
    def changeset(struct, attrs) do
      struct
      |> cast(attrs, @all_attributes)
      |> validate_required(@required_attributes)
      |> validate_filling_or_border_existence(attrs)
    end

    defp validate_filling_or_border_existence(changeset, attrs) do
        case Map.has_key?(attrs, "border_filling") or Map.has_key?(attrs, "inner_filling") do
            true -> changeset
            false ->  
            changeset
            |> Map.put(:valid?, false)
            |> add_error(:paramaters, "border_filling or inner_filling or both must be specified", [])
        end
    end
  end
  