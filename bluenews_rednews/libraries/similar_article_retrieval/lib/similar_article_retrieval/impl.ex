defmodule SimilarArticleRetrieval.Impl do
  @base_url "https://newsapi.org/v2"
  # @newsapi_key Application.get_env(:similar_article_retrieval, :newsapi_key)
  @newsapi_key "807829b7f8864563ac77a975581cba84"

  # 28 news source categorized by media bias
  @news_sources %{
    liberal: [
      "the-new-york-times",
      "bbc-news",
      "the-huffington-post",
      "politico",
      "msnbc",
      "cnn",
      "reddit-r-all",
      "new-york-magazine",
      "newsweek",
      "the-washington-post",
      "vice-news"
    ],
    conservative: [
      "the-american-conservative",
      "fox-news",
      "the-hill",
      "national-review",
      "the-wall-street-journal",
      "breitbart-news",
      "the-washington-times"
    ],
    non_partisan: [
      "reuters",
      "google-news",
      "axios",
      "al-jazeera-english",
      "associated-press",
      "usa-today",
      "time",
      "abc-news",
      "cbs-news",
      "nbc-news"
    ]
  }

  # default news sources for initial query search
  @default_news_srcs [
    "the-new-york-times",
    "bbc-news",
    "the-huffington-post",
    "politico",
    "msnbc",
    "the-american-conservative",
    "fox-news",
    "the-hill",
    "national-review",
    "the-wall-street-journal"
  ]

  # PRIMARY RETRIEVAL FUNCTIONS

  def get_all_articles(keywords) do
    IO.inspect @newsapi_key
    retrieve_articles(@default_news_srcs, process_keywords(keywords))
    |> filter_articles()
    |> classify_articles()
  end

  def get_all_sources() do
    retrieve_sources()
    |> filter_sources()
    |> classify_sources()
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
    IO.inspect results
    results
    |> Enum.map(fn result -> Enum.at(result["articles"], 0) end)
  end

  def classify_articles(articles) do
    IO.inspect articles
    articles
    |> Enum.map(fn article ->
      Map.put(article, "bias", identify_src_bias(article["source"]["id"]))
    end)
  end

  def retrieve_sources() do
    HTTPoison.get!(@base_url <> "/sources", [], params: config_params()).body
    |> Poison.decode!()
  end

  def filter_sources(results) do
    results["sources"]
    |> Enum.filter(fn source ->
      source["country"] == "us" && source["category"] == "general" && source["language"] == "en"
        || source["id"] == "the-wall-street-journal" || source["id"] == "bbc-news"
    end)
  end

  def classify_sources(sources) do
    sources
    |> Enum.map(fn source ->
      Map.put(source, "bias", identify_src_bias(source["id"]))
    end)
  end

  # NEWS API HELPER FUNCTIONS

  # params for getting sources
  def config_params() do
    %{
      apiKey: @newsapi_key
    }
  end

  # params for getting articles based on keyword and source
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

  # FOR TESTING PURPOSES

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
