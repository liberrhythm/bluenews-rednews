defmodule SimilarArticleRetrieval.Impl do
  @base_url "https://newsapi.org/v2"
  @newsapi_key Application.get_env(:similar_article_retrieval, :newsapi_key)

  @news_sources %{
    liberal: %{
      "The New York Times": "the-new-york-times",
      "BBC News": "bbc-news",
      "The Huffington Post": "the-huffington-post",
      "Politico": "politico",
      "MSNBC": "msnbc"
    },
    conservative: %{
      "The American Conservative": "the-american-conservative",
      "Fox News": "fox-news",
      "The Hill": "the-hill",
      "National Review": "national-review",
      "The Wall Street Journal": "the-wall-street-journal"
    },
    non_partisan: %{

    }
  }

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

  def is_liberal(src) do
    Map.has_key?(@news_sources.liberal, src)
  end

  def is_conservative(src) do
    Map.has_key?(@news_sources.conservative, src)
  end

  def is_non_partisan(src) do
    Map.has_key?(@news_sources.non_partisan, src)
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
  end

  def get_all_articles(keywords) do
    kw = process_keywords(keywords)
    get_articles(:liberal, kw)
    get_articles(:conservative, kw)
  end

  def get_articles(:liberal, keywords) do
    retrieve_articles(Map.values(@news_sources.liberal), keywords)
  end

  def get_articles(:conservative, keywords) do
    retrieve_articles(Map.values(@news_sources.conservative), keywords)
  end

  def retrieve_articles(sources, keywords) do
    sources
    |> Enum.map(fn src ->
      Task.async(fn -> SimilarArticleRetrieval.Impl.retrieve_article(keywords, src) end)
    end)
    |> Enum.map(fn work ->
      Task.await(work)
    end)
    |> Enum.concat()
  end
end
