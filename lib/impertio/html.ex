defmodule Impertio.HTMLGen do
  @doc """
  Convert an orgmode syntax tree to HTML.
  """

  @doc """
      iex> Impertio.HTMLGen.convert(Orgmode.parse!("#+TITLE: test"))
      "<h1>test</h1>"
  """
  def convert(tree) do
    metadata = tree.metadata
    sections = tree.sections

    generated =
      if metadata[:title] != nil do
        "<h1 id=\"title\">" <> metadata.title <> "</h1>"
      else
        ""
      end

    timestamp = if metadata[:time] do
      case DateTime.from_iso8601(metadata.time) do
        {:ok, datetime, _} -> "<span style=\"float: right;\">#{DateTime.to_string(datetime)}</span>"
        {:error, message} -> "<span style=\"float: right;\">#{metadata.time}</span>"
      end
    else
      ""
    end

    generated = generated <> if metadata[:author] do
      "<h4 id=\"article-info\" data-author=\"#{metadata.author}\">By: #{metadata.author}#{timestamp}</h4>"
    else
      "<h4 id=\"article-info\">#{timestamp}</h4>"
    end

    Enum.reduce(sections, generated, &handle_section/2)
  end

  def handle_section(section, generated) do
    generated =
      generated <>
        if section[:name] != nil do
          "<h#{section.level}>" <> section.name <> "</h#{section.level}>"
        else
          ""
        end

    if section[:content] != nil do
      Enum.reduce(section.content, generated, &handle_block/2)
    else
      generated
    end
  end

  def handle_block({:paragraph, text}, generated) do
    generated <> "<p>" <> text <> "</p>"
  end

  def handle_block({:src, %{args: [lang], content: content}}, generated) do
    generated <> "<pre class=\"language-#{lang}\"><code>" <> content <> "</code></pre>"
  end

  def handle_block({:table, cells}, generated) do
    generated <>
      "<table>" <>
      Enum.join(
        Enum.map(cells.cells, &format_row/1)
      ) <> "</table>"
  end

  defp format_row(row) do
    "<tr>" <> Enum.join(Enum.map(row, &format_cell/1)) <> "</tr>"
  end

  defp format_cell(cell) do
    "<td>" <> cell <> "</td>"
  end
end
