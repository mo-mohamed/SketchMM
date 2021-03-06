defmodule Sketch.ServiceModule.Shape.FloodFill do
    @moduledoc """
      This module contains functionalities for flood filling a canvas
    """
    
    use Sketch.DAL.CommonQueries, schema_module: Sketch.Schema.Shape

    @doc """
        Flood fills a canvas given a flooding characater and staring coordinates.
    """
    def draw(%Sketch.Schema.Canvas{meta_data: %{"height" => height, "width" => width}} = canvas,
     %{"x_coordinate" => x_coordinate,
      "y_coordinate" => y_coordinate,
      "filling" => inner_filling} = params
      ) do
       matrix = canvas.matrix
                |> flood_fill(x_coordinate, y_coordinate, inner_filling, height, width)
                
        with {:ok, _shape} <- Sketch.ServiceModule.Shape.FloodFill.create(%{canvas_id: canvas.id, meta_data: params, type: "flood_fill"}),
            {:ok, canvas} <- Sketch.ServiceModule.Canvas.update(canvas, %{matrix: matrix}) do
            {:ok, canvas}
        else
            {:error, error} -> {:error, error}
        end
    end

    @doc """
        Flood fills a canvas given a flooding characater and staring coordinates.
    """
    def draw(%Sketch.Schema.Canvas{meta_data: %{height: height, width: width}} = canvas,
     %{"x_coordinate" => x_coordinate,
      "y_coordinate" => y_coordinate,
      "filling" => inner_filling} = params
      ) do
       matrix = canvas.matrix
                |> flood_fill(x_coordinate, y_coordinate, inner_filling, height, width)
                
        with {:ok, _shape} <- Sketch.ServiceModule.Shape.FloodFill.create(%{canvas_id: canvas.id, meta_data: params, type: "flood_fill"}),
            {:ok, canvas} <- Sketch.ServiceModule.Canvas.update(canvas, %{matrix: matrix}) do
            {:ok, canvas}
        else
            {:error, error} -> {:error, error}
        end
    end


    @doc false
    defp flood_fill(matrix, x_coordinate, y_coordinate, filling, height, width) when (x_coordinate >= 0 and x_coordinate < width) and (y_coordinate >= 0 and y_coordinate < height)  do
        matrix = if !has_value?(matrix, x_coordinate, y_coordinate) do
            put_in(matrix[y_coordinate][x_coordinate], filling)
            |> flood_fill(x_coordinate, y_coordinate + 1, filling, height, width) # go up
            |> flood_fill(x_coordinate, y_coordinate - 1, filling, height, width) # go bottom
            |> flood_fill(x_coordinate - 1, y_coordinate , filling, height, width) # go left
            |> flood_fill(x_coordinate + 1, y_coordinate , filling, height, width) # go right
        else
            matrix
        end
    end

    @doc false
    defp flood_fill(matrix, _x_coordinate, _y_coordinate, _filling, _height, _width), do: matrix

    @doc false
    defp has_value?(matrix, x_coordinate, y_coordinate) do
        not is_nil(matrix[y_coordinate][x_coordinate])
    end
end