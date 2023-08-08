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

  defp cleanup_path(path) do
    cond do
      String.ends_with?(path, "/") -> Path.dirname(path)
      true -> path
    end
  end

  @doc """
      iex> Impertio.locate_file("/")
      {:ok, "test/data/index.org"}

      iex> Impertio.locate_file("../../../")
      {:error, "<401> Path attempted to access outside of data directory."}
  """
  def locate_file(path) do
    path = Path.join(data_dir(), cleanup_path(path))

    case Path.safe_relative_to(path, data_dir()) do
      {:ok, path} ->
        cond do
          File.exists?(path <> ".org") ->
            {:ok, path <> ".org"}

          File.exists?(path) and not File.dir?(path) ->
            {:ok, path}

          File.exists?(path) and File.dir?(path) and File.exists?(path <> "/index.org") ->
            {:ok, path <> "/index.org"}

          true ->
            {:error, "<404> Unable to locate file for path."}
        end

      :error ->
        {:error, "<401> Path attempted to access outside of data directory."}
    end
  end

  @error_regex ~r/<([0-9]+)>\s*([^\n]+)/
  def split_error(message) do
    cond do
      is_tuple(message) ->
        message

      Regex.match?(@error_regex, message) ->
        [error_code, error_message] = tl(Regex.run(@error_regex, message))

        {String.to_integer(error_code), error_message}

      true ->
        {500, message}
    end
  end
end
