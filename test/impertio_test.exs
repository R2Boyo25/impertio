defmodule ImpertioTest do
  use ExUnit.Case
  doctest Impertio
  doctest Impertio.HTMLGen

  test "Splits errors" do
    assert Impertio.split_error("<404> Not Found") == {404, "Not Found"}
    assert Impertio.split_error("Just a message") == {500, "Just a message"}
    assert Impertio.split_error({404, "Not Found"}) == {404, "Not Found"}
  end
end
