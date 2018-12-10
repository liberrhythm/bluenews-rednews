defmodule NewsfeedWeb.PageController do
  use NewsfeedWeb, :controller

  def index(conn, _params) do
    render conn, "index.html",
      liberal_articles: [],
      conservative_articles: [],
      nonpartisan_articles: [],
      other_sources: %{}
  end
end
