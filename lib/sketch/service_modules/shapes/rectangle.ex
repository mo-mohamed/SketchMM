defmodule Sketch.ServiceModule.Shape.Rectangle do
    @moduledoc """
      This module contains functionalities for flood filling a canvas
    """

    use Sketch.DAL.CommonQueries, schema_module: Sketch.Schema.Shape

    @doc """
        Draws a rectangle on a canvas provided rectangle paramaters and a canvas to draw on.
    """
    def draw(%Sketch.Schema.Canvas{} = canvas,
     %{"x_coordinate" => x_coordinate,
      "y_coordinate" => y_coordinate,
      "height" => height, 
      "width" => width, 
      "border_filling" => border_filling, 
      "inner_filling" => inner_filling} = params
      ) do
        matrix = 
        canvas.matrix
        |> draw_border(x_coordinate, y_coordinate, width - 1, height - 1, border_filling)
        |> fill_inner(x_coordinate, y_coordinate, width - 1, height - 1, inner_filling)

        with {:ok, _shape} <- Sketch.ServiceModule.Shape.Rectangle.create(%{canvas_id: canvas.id, meta_data: params, type: "rectangle"}),
             {:ok, canvas} <- Sketch.ServiceModule.Canvas.update(canvas, %{matrix: matrix}) do
             {:ok, canvas}
        else
        {:error, error} -> {:error, error}
        end
    end

    @doc false
    defp draw_border(matrix, _x_coordinate, _y_coordinate, _width, _height, border_filling) when is_nil(border_filling), do: matrix

    @doc false
    defp draw_border(matrix, x_coordinate, y_coordinate, width, height, border_filling) do
        matrix
        |> draw_border_top(x_coordinate, y_coordinate, width, height, border_filling)
        |> draw_border_bottom(x_coordinate, y_coordinate, width, height, border_filling)
        |> draw_border_left(x_coordinate, y_coordinate, width, height, border_filling)
        |> draw_border_right(x_coordinate, y_coordinate, width, height, border_filling)
    end

    @doc false
    defp draw_border_top(canvas, x, y, width, _height, filling) do
        Enum.reduce(x..(width+x), canvas, fn index, canvas -> 
            put_in(canvas[y][index], filling)
        end)
    end

    @doc false
    defp draw_border_bottom(canvas, x, y, width, height, filling) do
        Enum.reduce(x..(width+x), canvas, fn index, canvas -> 
            put_in(canvas[y+height][index], filling)
        end)
    end

    @doc false
    defp draw_border_left(canvas, x, y, _width, height, filling) do
        Enum.reduce(y+1..(height+y-1), canvas, fn index, canvas -> 
            put_in(canvas[index][x], filling)
        end)
    end

    @doc false
    defp draw_border_right(canvas, x, y, width, height, filling) do
        Enum.reduce(y+1..(height+y-1), canvas, fn index, canvas -> 
            put_in(canvas[index][x+width], filling)
        end)
    end

    @doc false
    defp fill_inner(matrix, _x, _y, _width, _height, filling) when is_nil(filling), do: matrix

    @doc false
    defp fill_inner(canvas, x, y, width, height, filling) do
        Enum.reduce(y+1..y+height-1, canvas, fn y_index, canvas -> 
            Enum.reduce(x+1..x+width-1, canvas, fn x_index, canvas -> 
                put_in(canvas[y_index][x_index], filling)
            end)
        end)
    end
end