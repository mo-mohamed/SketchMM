defmodule SketchWeb.Api.CanvasControllerTest do
    use SketchWeb.ConnCase
    alias Sketch.ServiceModule.Canvas
  
    describe "create canvas" do
        test "passing correct params", %{conn: conn} do
            width = 20
            height = 10
            params = %{ "width" => width, "height" => height }
      
            conn = post(conn, "/api/canvas", params)
            assert result = json_response(conn, 200)
            assert result["width"] == width
            assert result["height"] == height
            assert is_binary(result["id"])
            assert is_list(result["matrix"])
            
          end

          test "passing invalid width", %{conn: conn} do
            width = "invalid"
            height = 10
            params = %{ "width" => width, "height" => height }
      
            conn = post(conn, "/api/canvas", params)
            assert result = json_response(conn, 400)
            assert result["errors"] == %{"width" => ["is invalid"]}
          end

          test "passing invalid width and height", %{conn: conn} do
            width = "invalid"
            height = "invalid"
            params = %{ "width" => width, "height" => height }
      
            conn = post(conn, "/api/canvas", params)
            assert result = json_response(conn, 400)
            assert result["errors"] == %{"width" => ["is invalid"], "height" => ["is invalid"]}
           
          end
    end

    describe "show canvas" do
        test "passing valid id that exists", %{conn: conn} do
            width = 30
            height = 20
           {:ok, canvas} = Canvas.new(width, height)
      
            conn = get(conn, "/api/canvas/#{canvas.id}")
            assert result = json_response(conn, 200)
            assert result["width"] == width
            assert result["height"] == height
            assert is_binary(result["id"])
            assert is_list(result["matrix"])
          end

          test "passing valid id that doesn't exists", %{conn: conn} do
            conn = get(conn, "/api/canvas/#{Ecto.UUID.generate()}")
            assert response = json_response(conn, 404)
            assert response["errors"] == "not found"
          end

          test "passing invalid id", %{conn: conn} do
            conn = get(conn, "/api/canvas/invalid_id")
            assert response = json_response(conn, 400)
            assert response["errors"] == "please specify valid id"
          end
    end

    describe "error - draw rectangle on canvas" do
        test "passing canvas id that doesn't exist", %{conn: conn} do
            params = %{
                "x_coordinate" => 1,
                "y_coordinate" => 2,
                "height" => 2,
                "width" => 2,
                "border_filling" => "@",
                "inner_filling" => "@",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{Ecto.UUID.generate()}/draw", params)
            assert response = json_response(conn, 404)
            assert response["errors"] == "not found"
          end

          test "passing invalid shape type", %{conn: conn} do
            params = %{
                "x_coordinate" => 1,
                "y_coordinate" => 2,
                "height" => 2,
                "width" => 2,
                "border_filling" => "@",
                "inner_filling" => "@",
                "type" => "invalid"
            }
      
            conn = post(conn, "/api/canvas/#{Ecto.UUID.generate()}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] == "please specify valid type"
          end

          test "passing no border_filling and no inner_filling", %{conn: conn} do
            params = %{
                "x_coordinate" => 1,
                "y_coordinate" => 2,
                "height" => 2,
                "width" => 2,
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{Ecto.UUID.generate()}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] == %{"paramaters" => ["border_filling or inner_filling or both must be specified"]}
          end


          test "missing x_coordinate", %{conn: conn} do
            {:ok, canvas} = Canvas.new(10,10)
            params = %{
                "y_coordinate" => 2,
                "height" => 2,
                "width" => 2,
                "border_filling" => "@",
                "inner_filling" => "@",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] ==  %{"x_coordinate" => ["can't be blank"]}
          end

          test "missing y_coordinate", %{conn: conn} do
            {:ok, canvas} = Canvas.new(10,10)
            params = %{
                "x_coordinate" => 2,
                "height" => 2,
                "width" => 2,
                "border_filling" => "@",
                "inner_filling" => "@",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] ==  %{"y_coordinate" => ["can't be blank"]}
          end

          test "missing height", %{conn: conn} do
            {:ok, canvas} = Canvas.new(10,10)
            params = %{
                "x_coordinate" => 2,
                "y_coordinate" => 2,
                "width" => 2,
                "border_filling" => "@",
                "inner_filling" => "@",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] ==   %{"height" => ["can't be blank"]}
          end

          test "missing width", %{conn: conn} do
            {:ok, canvas} = Canvas.new(10,10)
            params = %{
                "x_coordinate" => 2,
                "y_coordinate" => 2,
                "height" => 2,
                "border_filling" => "@",
                "inner_filling" => "@",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] ==  %{"width" => ["can't be blank"]}
          end

          test "invalid width", %{conn: conn} do
            {:ok, canvas} = Canvas.new(10,10)
            params = %{
                "x_coordinate" => 2,
                "y_coordinate" => 2,
                "width" => "invalid",
                "height" => 2,
                "border_filling" => "@",
                "inner_filling" => "@",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] ==  %{"width" => ["is invalid"]}
          end

          test "invalid height", %{conn: conn} do
            {:ok, canvas} = Canvas.new(10,10)
            params = %{
                "x_coordinate" => 2,
                "y_coordinate" => 2,
                "width" => 2,
                "height" => "invalid",
                "border_filling" => "@",
                "inner_filling" => "@",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] ==  %{"height" => ["is invalid"]}
          end

          test "invalid x_coordinate", %{conn: conn} do
            {:ok, canvas} = Canvas.new(10,10)
            params = %{
                "x_coordinate" => "invalid",
                "y_coordinate" => 2,
                "width" => 2,
                "height" => 2,
                "border_filling" => "@",
                "inner_filling" => "@",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] ==  %{"x_coordinate" => ["is invalid"]}
          end

          test "invalid y_coordinate", %{conn: conn} do
            {:ok, canvas} = Canvas.new(10,10)
            params = %{
                "x_coordinate" => 2,
                "y_coordinate" => "invalid",
                "width" => 2,
                "height" => 2,
                "border_filling" => "@",
                "inner_filling" => "@",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] ==  %{"y_coordinate" => ["is invalid"]}
          end
    end

    describe "error flood filling a canvas" do
      test "missing flood x_coordinate", %{conn: conn} do
        params = %{
            "y_coordinate" => 1,
            "filling" => "@",
            "type" => "flood_fill"
        }
  
        conn = post(conn, "/api/canvas/#{Ecto.UUID.generate()}/draw", params)
        assert response = json_response(conn, 400)
        assert response["errors"] == %{"x_coordinate" => ["can't be blank"]}
      end

      test "missing flood y_coordinate", %{conn: conn} do
        params = %{
            "x_coordinate" => 1,
            "filling" => "@",
            "type" => "flood_fill"
        }
  
        conn = post(conn, "/api/canvas/#{Ecto.UUID.generate()}/draw", params)
        assert response = json_response(conn, 400)
        assert response["errors"] == %{"y_coordinate" => ["can't be blank"]}
      end

      test "missing flood filling", %{conn: conn} do
        params = %{
            "x_coordinate" => 1,
            "y_coordinate" => 1,
            "type" => "flood_fill"
        }
  
        conn = post(conn, "/api/canvas/#{Ecto.UUID.generate()}/draw", params)
        assert response = json_response(conn, 400)
        assert response["errors"] == %{"filling" => ["can't be blank"]}
      end
    end

    describe "success - draw on canvas" do
        test "successfully drawing rectangles on canvas and filling", %{conn: conn} do
            {:ok, canvas} = Canvas.new(20, 20)
            params = %{
                "x_coordinate" => 2,
                "y_coordinate" => 2,
                "height" => 6,
                "width" => 6,
                "border_filling" => "@",
                "inner_filling" => "*",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 200)

            expected_matrix = [
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "@", "@", "@", "@", "@", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "*", "*", "*", "*", "@", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "*", "*", "*", "*", "@", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "*", "*", "*", "*", "@", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "*", "*", "*", "*", "@", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "@", "@", "@", "@", "@", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
            ]

              assert response["matrix"] == expected_matrix

              params_2 = %{
                "x_coordinate" => 6,
                "y_coordinate" => 6,
                "height" => 3,
                "width" => 3,
                "border_filling" => "$",
                "inner_filling" => "$",
                "type" => "rectangle"
            }

            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params_2)

            expected_matrix = [
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "@", "@", "@", "@", "@", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "*", "*", "*", "*", "@", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "*", "*", "*", "*", "@", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "*", "*", "*", "*", "@", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "*", "*", "*", "$", "$", "$", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, "@", "@", "@", "@", "$", "$", "$", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, "$", "$", "$", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
            ]

            assert response = json_response(conn, 200)
            assert response["matrix"] == expected_matrix

            filling_params = %{"x_coordinate" => 10, "y_coordinate" => 10, "filling" => "-", "type" => "flood_fill"}
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", filling_params)

            expected_matrix = [
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "@", "@", "@", "@", "@", "@", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "@", "*", "*", "*", "*", "@", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "@", "*", "*", "*", "*", "@", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "@", "*", "*", "*", "*", "@", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "@", "*", "*", "*", "$", "$", "$", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "@", "@", "@", "@", "$", "$", "$", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "$", "$", "$", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
              ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
            ]

            assert response = json_response(conn, 200)
            assert response["matrix"] == expected_matrix
        end
    end

    describe "error - out of canvas boundaries" do
      test "out of boundaries/1", %{conn: conn} do
        {:ok, canvas} = Canvas.new(20, 15)
            params = %{
                "x_coordinate" => 2,
                "y_coordinate" => 2,
                "height" => 12,
                "width" => 18,
                "border_filling" => "@",
                "inner_filling" => "*",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] == "cannot draw out of canvas boundaries"

            canvas = Canvas.get!(canvas.id)
            expected_matrix = [
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
            ]

            assert Canvas.to_list(canvas.matrix) == expected_matrix
          
      end

      test "out of boundaries/2", %{conn: conn} do
        {:ok, canvas} = Canvas.new(20, 15)
            params = %{
                "x_coordinate" => -1,
                "y_coordinate" => -1,
                "height" => 5,
                "width" => 5,
                "border_filling" => "@",
                "inner_filling" => "*",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] == "cannot draw out of canvas boundaries"

            canvas = Canvas.get!(canvas.id)
            expected_matrix = [
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
            ]

            assert Canvas.to_list(canvas.matrix) == expected_matrix
      end


      test "out of boundaries/3", %{conn: conn} do
        {:ok, canvas} = Canvas.new(20, 15)
            params = %{
                "x_coordinate" => 3,
                "y_coordinate" => 4,
                "height" => 18,
                "width" => 5,
                "border_filling" => "@",
                "inner_filling" => "*",
                "type" => "rectangle"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] == "cannot draw out of canvas boundaries"

            canvas = Canvas.get!(canvas.id)
            expected_matrix = [
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
            ]

            assert Canvas.to_list(canvas.matrix) == expected_matrix
      end

      test "flood point out of boundary", %{conn: conn} do
        {:ok, canvas} = Canvas.new(20, 15)
            params = %{
                "x_coordinate" => 20,
                "y_coordinate" => 20,
                "filling" => "@",
                "type" => "flood_fill"
            }
      
            conn = post(conn, "/api/canvas/#{canvas.id}/draw", params)
            assert response = json_response(conn, 400)
            assert response["errors"] == "cannot draw out of canvas boundaries"

            canvas = Canvas.get!(canvas.id)
            expected_matrix = [
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
            ]

            assert Canvas.to_list(canvas.matrix) == expected_matrix
           
      end
    end
   
  
  end
  