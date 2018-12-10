defmodule NewsfeedWeb.PageCommander do
  use Drab.Commander

  # Place your event handlers here

  defhandler url_searchbtn_clicked(socket, _sender) do

    # reset other_sources
    other_sources = SimilarArticleRetrieval.get_other_sources_map()
    put_store(socket, :other_sources, other_sources)
    poke(socket, "index.html", other_sources: other_sources)

    # reset other input
    set_prop(socket, "#kwd-user-input", value: "")

    query = query(socket, "#url-user-input", :value)
    case query do
      {:ok, values} ->
        user_input = values["#url-user-input"]["value"]
        article = ArticleProcessing.process_article(user_input)
        IO.inspect article
        keywords = article.keywords
        IO.inspect keywords

        put_store(socket, :keywords, keywords)
        articles = SimilarArticleRetrieval.get_all_articles(keywords)

        IO.inspect articles

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

  defhandler kwd_searchbtn_clicked(socket, _sender) do

    # reset other_sources
    other_sources = SimilarArticleRetrieval.get_other_sources_map()
    put_store(socket, :other_sources, other_sources)
    poke(socket, "index.html", other_sources: other_sources)

    # reset other input
    set_prop(socket, "#url-user-input", value: "")

    query = query(socket, "#kwd-user-input", :value)
    case query do
      {:ok, values} ->
        keywords = values["#kwd-user-input"]["value"]
          |> String.split(", ")

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

  defhandler srcbtn_clicked(socket, _sender, key) do
    # get relevant information
    key_atom = String.to_atom(key)
    other_sources = get_store(socket, :other_sources)
    value = Map.get(other_sources, key_atom)

    # add article to newsfeed
    keywords = ["investigation", "fbi", "mueller"]
    article = Enum.at(SimilarArticleRetrieval.get_one_article(keywords, value), 0)
    add_article(article["bias"], socket, article)

    # remove news source as available option
    updated_sources = Map.delete(other_sources, key_atom)
    put_store(socket, :other_sources, updated_sources)
    poke(socket, "index.html", other_sources: updated_sources)
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
    # resize columns when nonpartisan news sources are pulled
    set_style(socket, "#non-partisan-container", display: "block")
    set_prop(socket, "#liberal-container", %{"attributes" => %{"class" => "col-sm-4"}})
    set_prop(socket, "#conservative-container", %{"attributes" => %{"class" => "col-sm-4"}})

    updated_articles = [ article | get_store(socket, :nonpartisan_articles) ]
    put_store(socket, :nonpartisan_articles, updated_articles)
    poke(socket, "index.html", nonpartisan_articles: updated_articles)
  end

  # defp resize_bias_columns(socket) do
  #   IO.inspect query_one(socket, "#liberal-container", :height)
  #   # height2 = query_one(socket, "#conservative-container", property_or_properties_list)
  # end

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

