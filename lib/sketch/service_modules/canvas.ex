defmodule Sketch.ServiceModule.Canvas do

    @moduledoc """
      This module for creating and retrieving canvases
    """

    use Sketch.DAL.CommonQueries, schema_module: Sketch.Schema.Canvas
    defoverridable get!: 2, get: 2
    
    @doc """
        Get canvas by id and retrieving options may be specified, throws error if canvas doesn't exist
    """
    def get!(id, opts \\ []) do
       canvas = super(id, opts)
       matrix = convert_matrix_keys(canvas.matrix)
       Map.put(canvas, :matrix, matrix)
    end

     @doc """
        Get canvas by id and retrieving options may be specified
        Retures {:ok, canvas} or {:error, :not_found}
    """
    def get(id, opts \\ []) do
        case super(id, opts) do
            {:ok, canvas} ->
                matrix = convert_matrix_keys(canvas.matrix)
                {:ok, Map.put(canvas, :matrix, matrix)}
            {:error, error} -> {:error, error}
        end
     end

     #convert matrix keys to integers to preserve order
     defp convert_matrix_keys(matrix) do
        for {key, value} <- matrix, into: %{}, do: {String.to_integer(key), (for {inner_key, inner_value} <- value, into: %{}, do: {String.to_integer(inner_key), inner_value})}
     end

    @doc """
        Creates a new canvas given its width and height
    """
    def new(width, height) do
        rows = height
        columns = width
        rows_range = 0..rows-1
        columns_range = 0..columns-1
        matrix = Enum.reduce(rows_range, %{}, fn index, canvas -> Map.put(canvas, index, draw_columns(columns_range)) end)

        %{
            :meta_data => %{width: columns, height: rows},
            :matrix => matrix,
            :type => "canvas"
        }
        |> create()
    end

    @doc false
    defp draw_columns(columns_range) do
        Enum.reduce(columns_range, %{}, fn index, canvas -> Map.put(canvas, index, nil) end)
    end

    @doc false
    def to_list(matrix) when is_map(matrix) do
        do_to_list(matrix)
    end
    
    @doc false
    defp do_to_list(matrix) when is_map(matrix) do
        Enum.to_list(matrix)
        |> Enum.sort_by(&(elem(&1, 0)))
        |> Enum.map(fn(x) -> elem(x, 1) end)
        |> Enum.map(fn(x) -> do_to_list(x) end)
      end

    @doc false
    defp do_to_list(matrix), do: matrix
end