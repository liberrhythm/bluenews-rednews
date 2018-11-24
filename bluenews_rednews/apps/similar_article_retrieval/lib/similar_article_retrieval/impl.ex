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
    non_partisan: %{

    }
  }

  @default_news_srcs Map.values(Map.merge(@news_sources.liberal, @news_sources.conservative))

  def get_all_sources() do
    HTTPoison.get!(@base_url <> "/sources", [], params: [{"apiKey", @newsapi_key}]).body
    |> Poison.decode!()
  end

  def process_keywords(keywords) do
    Enum.join(keywords, " OR ")
  end

  def encode_params(keywords, source) do
    params = %{
      q: process_keywords(keywords),
      sources: source,
      sortBy: "relevancy",
      apiKey: @newsapi_key
    }

    URI.encode_query(params)
  end

  def config_params(keywords, source) do
    %{
      q: keywords,
      sources: source,
      sortBy: "relevancy",
      apiKey: @newsapi_key
    }
  end

  # use fetch value or have key?
  def is_liberal(src) do
    Map.has_key?(@news_sources.liberal, src)
  end

  def is_conservative(src) do
    Map.has_key?(@news_sources.conservative, src)
  end

  def is_non_partisan(src) do
    Map.has_key?(@news_sources.non_partisan, src)
  end

  def print_news_sources(src) do
    @news_sources.liberal
  end

  def identify_src_bias(src) do
    cond do
      is_liberal(src) -> :liberal
      is_conservative(src) -> :conservative
      is_non_partisan(src) -> :non_partisan
      true -> :none
    end
  end

  def retrieve_article(keywords, source) do
    HTTPoison.get!(@base_url <> "/everything", [], params: config_params(keywords, source)).body
    |> Poison.decode!()
    # |> Map.new()
  end

  def get_all_articles(keywords) do
    retrieve_articles(@default_news_srcs, process_keywords(keywords))
    |> filter_articles()
    |> classify_articles()
  end

  def get_one_article() do
    retrieve_articles(["the-hill"], process_keywords(["bitcoin"]))
    |> filter_articles()
    |> classify_articles()
  end

  def print() do
    @default_news_srcs
  end

  def get_two_articles() do
    retrieve_articles(["the-hill", "the-wall-street-journal"], process_keywords(["bitcoin"]))
    |> filter_articles()
    |> classify_articles()
  end

  # def get_articles(:liberal, keywords) do
  #   retrieve_articles(Map.values(@news_sources.liberal), keywords)
  # end

  # def get_articles(:conservative, keywords) do
  #   retrieve_articles(Map.values(@news_sources.conservative), keywords)
  # end

  def retrieve_articles(sources, keywords) do
    sources
    |> Enum.map(fn src ->
      Task.async(fn -> SimilarArticleRetrieval.Impl.retrieve_article(keywords, src) end)
    end)
    |> Enum.map(fn work ->
      Task.await(work)
    end)
    # |> Enum.concat()
  end

  # need to handle no results back
  def filter_articles(results) do
    results
    |> Enum.map(fn result -> Enum.at(result["articles"], 0) end)
  end

  def classify_articles(articles) do
    articles
    |> Enum.map(fn article ->
      Map.put(article, "bias", identify_src_bias(article["source"]["name"]))
    end)
  end
end
