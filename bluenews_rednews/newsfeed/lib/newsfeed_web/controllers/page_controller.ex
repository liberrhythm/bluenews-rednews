defmodule NewsfeedWeb.PageController do
  use NewsfeedWeb, :controller

  def index(conn, _params) do
    # assign(conn, :liberal_articles, ["hello"])
    # assign(conn, :conservative_articles, ["blahhhhh"])

    # IO.inspect conn.assigns[:liberal_articles]
    render conn, "index.html", liberal_articles: [], conservative_articles: []
  end
end
