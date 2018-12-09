defmodule NewsfeedWeb.PageCommander do
  use Drab.Commander

  # Place your event handlers here

  defhandler button_clicked(socket, _sender) do
    query = query(socket, "#user-input", :value)
    case query do
      {:ok, _values} ->
        # user_input = values["#user-input"]["value"]

        # article = ArticleProcessing.process_article(user_input)

        # IO.inspect article.keywords
        keywords = ["investigation", "fbi", "mueller"]
        articles = SimilarArticleRetrieval.get_all_articles(keywords)

        liberal_articles = Enum.filter(articles, fn art -> art["bias"] == :liberal end)
        conservative_articles = Enum.filter(articles, fn art -> art["bias"] == :conservative end)

        poke(socket, "index.html", liberal_articles: liberal_articles)
        poke(socket, "index.html", conservative_articles: conservative_articles)

      _ ->
        nil
    end
  end

  # Place your callbacks here

  onload :page_loaded

  def page_loaded(socket) do
    nil
  end
end

