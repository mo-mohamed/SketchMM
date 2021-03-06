defmodule SketchWeb.Api.CanvasView do
    use SketchWeb, :view

    def render("create.json", %{canvas: canvas}) do
        %{
          id: canvas.id,
          width: canvas.meta_data.width,
          height: canvas.meta_data.height,
          matrix: Sketch.ServiceModule.Canvas.to_list(canvas.matrix)
        }
      end

      def render("show.json", %{canvas: canvas}) do
        %{
          id: canvas.id,
          width: canvas.meta_data["width"],
          height: canvas.meta_data["height"],
          matrix: Sketch.ServiceModule.Canvas.to_list(canvas.matrix)
        }
      end
end