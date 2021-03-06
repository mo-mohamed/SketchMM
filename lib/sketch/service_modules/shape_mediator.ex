defmodule Sketch.ServiceModule.ShapeMediator do

    @moduledoc """
      Mediator is responsible for taking a draw request and calls the actual model for drawing 
      depending on the shape type, also calls shape validation layer if needed
    """

    alias Sketch.ServiceModule.Shape.{Rectangle, FloodFill,Validation}

    @doc """
        Request to draw a shape.
    """
    def draw(:rectangle, canvas, params) do
        params = Map.put_new(params, "inner_filling", nil) |> Map.put_new("border_filling", nil)
        case Validation.valid?(:rectangle, params, canvas) do
            true -> Rectangle.draw(canvas, params)
            false -> {:error, :out_of_boundary}
        end
        
    end

    @doc """
        Request to draw a shape.
    """
    def draw(:flood_fill, canvas, params) do
        case Validation.valid?(:flood_fill, params, canvas) do
            true -> FloodFill.draw(canvas, params)
            false -> {:error, :out_of_boundary}
        end
       
    end
end