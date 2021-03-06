defmodule Sketch.ServiceModule.Shape.Validation do

    @moduledoc """
      provides drawing validations, should be used before the actual drawing.
      Currently provides validation for:
      1- out of boundary validation.
    """

   @doc """
        validates if applicable for to draw a shape on a given canvas.
   """
   def valid?(:rectangle,
    %{"x_coordinate" => x_coordinate, "y_coordinate" => y_coordinate, "width" => width, "height" => height} = _params,
     %Sketch.Schema.Canvas{meta_data: %{width: canvas_width, height: canvas_height}} = _canvas) do

      (x_coordinate >= 0 and y_coordinate >= 0 and (x_coordinate + width) <= (canvas_width - 1) and (y_coordinate + height) <= (canvas_height - 1))
   end

   @doc """
        validates if applicable for to draw a shape on a given canvas.
   """
   def valid?(:rectangle,
   %{"x_coordinate" => x_coordinate, "y_coordinate" => y_coordinate, "width" => width, "height" => height} = _params,
    %Sketch.Schema.Canvas{meta_data: %{"width" => canvas_width, "height" => canvas_height}} = _canvas) do

      (x_coordinate >= 0 and y_coordinate >= 0 and (x_coordinate + width) <= (canvas_width - 1) and (y_coordinate + height) <= (canvas_height - 1))
   end

   @doc """
        validates if applicable for to draw a shape on a given canvas.
   """
   def valid?(:flood_fill,
   %{"x_coordinate" => x_coordinate, "y_coordinate" => y_coordinate} = _params,
    %Sketch.Schema.Canvas{meta_data: %{"width" => canvas_width, "height" => canvas_height}} = _canvas) do
      
      (x_coordinate >= 0 and y_coordinate >= 0 and x_coordinate < canvas_width and y_coordinate < canvas_height)
   end

   @doc """
        validates if applicable for to draw a shape on a given canvas.
   """
   def valid?(:flood_fill,
  %{"x_coordinate" => x_coordinate, "y_coordinate" => y_coordinate} = _params,
   %Sketch.Schema.Canvas{meta_data: %{width: canvas_width, height: canvas_height}} = _canvas) do
     
      (x_coordinate >= 0 and y_coordinate >= 0 and x_coordinate < canvas_width and y_coordinate < canvas_height)
  end
end
