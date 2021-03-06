defmodule SketchWeb.Api.CanvasController do

    @moduledoc """
      Api endpoints for working with canvas
    """

    use SketchWeb, :controller
    alias Sketch.ServiceModule.Canvas
    alias SketchWeb.Validations.Api.CanvasValidation
    alias SketchWeb.Api.ErrorView
    alias Sketch.ServiceModule.ShapeMediator

    @doc """
        create new canvas.
    """
    def create(conn, params) do
        paramaters_changset = param_validations(CanvasValidation.Create, [%CanvasValidation.Create{}, params])
        
        if paramaters_changset.valid? == false do
          error_views(conn, 400, changeset: paramaters_changset)
        else
            case Canvas.new(params["width"], params["height"]) do
                {:ok, canvas} -> conn |> render("create.json", canvas: canvas)
                {:error, error} -> error_views(conn, 400, error: error)
            end
        end
    end

    @doc """
        show canvas by id.
    """
    def show(conn, %{"id" => id} = _params) do
        case Canvas.get(id) do
            {:ok, canvas} ->  conn |> render("show.json", canvas: canvas)
            {:error, :bad_request} -> error_views(conn, 400, %{errors: "please specify valid id"})
            {:error, :not_found} -> error_views(conn, 404, %{errors: "not found"})
        end
    end

    @doc """
        draw shape on canvas.
    """
    def draw(conn, %{"type" => "rectangle"} = params) do
        paramaters_changset = param_validations(CanvasValidation.Rectangle.Create, [%CanvasValidation.Rectangle.Create{}, params])
        if paramaters_changset.valid? == false do
            error_views(conn, 400, changeset: paramaters_changset)
        else
            case Canvas.get(params["canvas_id"]) do
                {:ok, canvas} -> 
                    case ShapeMediator.draw(:rectangle, canvas, params) do
                        {:ok, canvas} -> conn |> render("show.json", canvas: canvas)
                        {:error, :out_of_boundary} ->  error_views(conn, 400, %{errors: "cannot draw out of canvas boundaries"})
                        {:error, error} ->  error_views(conn, 400, %{errors: error})
                    end
                {:error, :bad_request} -> error_views(conn, 400, %{errors: "please specify valid canvas id"})
                {:error, :not_found} -> error_views(conn, 404, %{errors: "not found"})
            end
        end
    end

    @doc """
        draw shape on canvas.
    """
    def draw(conn, %{"type" => "flood_fill"} = params) do
        paramaters_changset = param_validations(CanvasValidation.FloodFill.Create, [%CanvasValidation.FloodFill.Create{}, params])
        if paramaters_changset.valid? == false do
            error_views(conn, 400, changeset: paramaters_changset)
        else
            case Canvas.get(params["canvas_id"]) do
                {:ok, canvas} -> 
                    case ShapeMediator.draw(:flood_fill, canvas, params) do
                        {:ok, canvas} -> conn |> render("show.json", canvas: canvas)
                        {:error, :out_of_boundary} ->  error_views(conn, 400, %{errors: "cannot draw out of canvas boundaries"})
                        {:error, error} -> error_views(conn, 400, %{errors: error})
                    end
                {:error, :bad_request} -> error_views(conn, 400, %{errors: "please specify valid canvas id"})
                {:error, :not_found} -> error_views(conn, 404, %{errors: "not found"})
            end
        end
    end

    @doc """
        draw shape on canvas.
    """
    def draw(conn, _), do: error_views(conn, 400, %{errors: "please specify valid type"})
      

    defp param_validations(module, params) do
        apply(module, :changeset, params)
    end
    
    defp error_views(conn, status, params) do
        conn
        |> put_status(status)
        |> put_view(ErrorView)
        |> render("error.json", params)
    end
end