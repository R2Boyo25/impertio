defmodule Impertio do
  @moduledoc """
  Impertio keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def data_dir() do
    dir = Application.get_env(:impertio, ImpertioWeb.Endpoint)[:data_dir]
    
    if not File.exists?(dir) do
      File.mkdir!(dir)
    end
    
    dir
  end
  
  def get_categories() do
    dir = Impertio.data_dir()
    File.ls!(dir)
    |> Enum.filter(&File.dir?(Path.join(dir, &1)))
  end
end
