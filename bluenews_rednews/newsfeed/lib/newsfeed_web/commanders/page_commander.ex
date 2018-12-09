defmodule NewsfeedWeb.PageCommander do
  use Drab.Commander

  # Place your event handlers here

  defhandler searchbtn_clicked(socket, _sender) do
    query = query(socket, "#user-input", :value)
    case query do
      {:ok, _values} ->
        # user_input = values["#user-input"]["value"]

        # article = ArticleProcessing.process_article(user_input)

        # IO.inspect article.keywords
        keywords = ["investigation", "fbi", "mueller"]
        put_store(socket, :keywords, keywords)
        articles = SimilarArticleRetrieval.get_all_articles(keywords)

        liberal_articles = Enum.filter(articles, fn art -> art["bias"] == :liberal end)
        conservative_articles = Enum.filter(articles, fn art -> art["bias"] == :conservative end)

        put_store(socket, :liberal_articles, liberal_articles)
        put_store(socket, :conservative_articles, conservative_articles)

        poke(socket, "index.html", liberal_articles: liberal_articles)
        poke(socket, "index.html", conservative_articles: conservative_articles)

      _ ->
        nil
    end
  end

  defhandler srcbtn_clicked(socket, _sender, value) do
    keywords = ["investigation", "fbi", "mueller"]
    article = Enum.at(SimilarArticleRetrieval.get_one_article(keywords, value), 0)
    add_article(article["bias"], socket, article)
  end

  defp add_article(:liberal, socket, article) do
    updated_articles = [ article | get_store(socket, :liberal_articles) ]
    put_store(socket, :liberal_articles, updated_articles)
    poke(socket, "index.html", liberal_articles: updated_articles)
  end

  defp add_article(:conservative, socket, article) do
    updated_articles = [ article | get_store(socket, :conservative_articles) ]
    put_store(socket, :conservative_articles, updated_articles)
    poke(socket, "index.html", conservative_articles: updated_articles)
  end

  defp add_article(:non_partisan, socket, article) do
    updated_articles = [ article | get_store(socket, :nonpartisan_articles) ]
    put_store(socket, :nonpartisan_articles, updated_articles)
    poke(socket, "index.html", nonpartisan_articles: updated_articles)
  end

  # Place your callbacks here

  onload :page_loaded

  def page_loaded(socket) do
    put_store(socket, :liberal_articles, [])
    put_store(socket, :conservative_articles, [])
    put_store(socket, :nonpartisan_articles, [])

    other_sources = SimilarArticleRetrieval.get_other_sources_map()
    put_store(socket, :other_sources, other_sources)
    poke(socket, "index.html", other_sources: other_sources)
  end
end

