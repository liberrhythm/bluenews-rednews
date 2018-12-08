defmodule ArticleProcessingTest do
  use ExUnit.Case
  doctest ArticleProcessing

  test "greets the world" do
    assert ArticleProcessing.hello() == :world
  end
end
