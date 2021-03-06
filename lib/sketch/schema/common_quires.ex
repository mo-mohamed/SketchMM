defmodule Sketch.DAL.CommonQueries do
    @moduledoc """
      Provides common database operations as a macoro.
      Use this module and pass it a module name to have the database operations included.
    """

    alias Sketch.Repo
    import Ecto.Query
  
    defmacro __using__(opts) do
      quote do
        alias Sketch.Repo
        import Ecto.Query, only: [from: 2, preload: 2, select: 3, order_by: 3]
  
        alias unquote(opts[:schema_module])
  
        def get!(id, opts \\ []),
          do: Sketch.DAL.CommonQueries.get!(unquote(opts[:schema_module]), id, opts)
  
        def get(id, opts \\ []),
          do: Sketch.DAL.CommonQueries.get(unquote(opts[:schema_module]), id, opts)
  
        def create(params), do: Sketch.DAL.CommonQueries.create(unquote(opts[:schema_module]), params)

        def update(%unquote(opts[:schema_module]){} = arg, %{} = attrs),
          do: Sketch.DAL.CommonQueries.update(unquote(opts[:schema_module]), arg, attrs)
      end
    end
  
    def get!(module, id, opts \\ [])
  
    def get!(module, id, opts) when is_atom(opts), do: get!(module, id, preloads: opts)
  
    def get!(module, id, opts) do
      preloads = Keyword.get(opts, :preloads, [])
      select_block = Keyword.get(opts, :select, [])
      return_type = Keyword.get(opts, :type, :struct)
  
      module
      |> select_function(return_type, select_block)
      |> preload(^preloads)
      |> Repo.get!(id)
    end
  
    def get(module, id, opts \\ [])
  
    def get(module, id, opts) when is_atom(opts), do: get(module, id, preloads: opts)
  
    def get(module, id, opts) do
      preloads = Keyword.get(opts, :preloads, [])
      select_block = Keyword.get(opts, :select, [])
      return_type = Keyword.get(opts, :type, :struct)
  
      queryable =
        module
        |> select_function(return_type, select_block)
        |> preload(^preloads)
  
      with {:ok, uuid} <- Ecto.UUID.cast(id),
           result when not is_nil(result) <- Repo.get(queryable, uuid) do
        {:ok, result}
      else
        :error -> {:error, :bad_request}
        _ -> {:error, :not_found}
      end
    end
  
    def create(module, params) do
      struct(module)
      |> module.changeset(params)
      |> Repo.insert()
    end
  
    def update(module, arg, %{} = attrs) do
      arg
      |> module.changeset(attrs)
      |> Repo.update()
    end
  
    defp select_function(schema_struct, _return_type, []) do
      schema_struct
    end
  
    defp select_function(schema_struct, :map, select_block) when is_list(select_block) do
      select(schema_struct, [schema], map(schema, ^select_block))
    end
  
    defp select_function(schema_struct, :struct, select_block) when is_list(select_block) do
      select(schema_struct, [schema], struct(schema, ^select_block))
    end
  
    defp select_function(schema_struct, :tuple, select_block) when is_list(select_block) do
      select(schema_struct, [schema], map(schema, ^select_block))
    end
  end
  