defmodule SimilarArticleRetrieval.Impl do
  @base_url "https://newsapi.org/v2"
  @newsapi_key Application.get_env(:similar_article_retrieval, :newsapi_key)

  @news_sources %{
    liberal: [
      "the-new-york-times",
      "bbc-news",
      "the-huffington-post",
      "politico",
      "msnbc"
    ],
    conservative: [
      "the-american-conservative",
      "fox-news",
      "the-hill",
      "national-review",
      "the-wall-street-journal"
    ],
    non_partisan: []
  }

  @default_news_srcs Enum.concat(@news_sources.liberal, @news_sources.conservative)

  # PRIMARY RETRIEVAL FUNCTIONS

  def get_all_sources() do
    HTTPoison.get!(@base_url <> "/sources", [], params: [{"apiKey", @newsapi_key}]).body
    |> Poison.decode!()
  end

  def get_all_articles(keywords) do
    retrieve_articles(@default_news_srcs, process_keywords(keywords))
    |> filter_articles()
    |> classify_articles()
  end

  # RETRIEVAL, FILTER, CLASSIFY FUNCTIONS
  # TO DO: handle no results back or error from News API

  def retrieve_article(keywords, source) do
    HTTPoison.get!(@base_url <> "/everything", [], params: config_params(keywords, source)).body
    |> Poison.decode!()
  end

  def retrieve_articles(sources, keywords) do
    sources
    |> Enum.map(fn src ->
      Task.async(fn -> SimilarArticleRetrieval.Impl.retrieve_article(keywords, src) end)
    end)
    |> Enum.map(fn work ->
      Task.await(work)
    end)
  end

  def filter_articles(results) do
    results
    |> Enum.map(fn result -> Enum.at(result["articles"], 0) end)
  end

  def classify_articles(articles) do
    articles
    |> Enum.map(fn article ->
      Map.put(article, "bias", identify_src_bias(article["source"]["id"]))
    end)
  end

  # NEWS API HELPER FUNCTIONS

  def config_params(keywords, source) do
    %{
      q: keywords,
      sources: source,
      sortBy: "relevancy",
      apiKey: @newsapi_key
    }
  end

  # CLASSIFICATION HELPER FUNCTIONS

  def is_liberal(src) do
    Enum.member?(@news_sources.liberal, src)
  end

  def is_conservative(src) do
    Enum.member?(@news_sources.conservative, src)
  end

  def is_non_partisan(src) do
    Enum.member?(@news_sources.non_partisan, src)
  end

  def process_keywords(keywords) do
    Enum.join(keywords, " OR ")
  end

  def identify_src_bias(src) do
    cond do
      is_liberal(src) -> :liberal
      is_conservative(src) -> :conservative
      is_non_partisan(src) -> :non_partisan
      true -> :none
    end
  end

  # TESTING PURPOSES

  def get_one_article() do
    retrieve_articles(["the-hill"], process_keywords(["bitcoin"]))
    |> filter_articles()
    |> classify_articles()
  end

  def get_two_articles() do
    retrieve_articles(["the-hill", "the-wall-street-journal"], process_keywords(["bitcoin"]))
    |> filter_articles()
    |> classify_articles()
  end

end
