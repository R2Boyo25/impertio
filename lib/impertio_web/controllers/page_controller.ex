defmodule ImpertioWeb.PageController do
  use ImpertioWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    case Impertio.locate_file("/") do
      {:ok, path} ->
        render(conn, :home,
          layout: false,
          page_content: Impertio.HTMLGen.convert(Orgmode.parse_file!(path))
        )

      {:error, message} ->
        {code, error_message} = Impertio.split_error(message)
        ImpertioWeb.ErrorHTML.render(Integer.to_string(code) <> ".html", message: error_message)
    end
  end
end
