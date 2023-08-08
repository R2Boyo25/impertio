defmodule ImpertioWeb.PageControllerTest do
  use ImpertioWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    html_response(conn, 200)
  end
end
