defmodule SimilarArticleRetrieval.Impl do

  @base_url "https://newsapi.org/v2"
  @newsapi_key Application.get_env(:similar_article_retrieval, :newsapi_key)

  @default_news_sources %{
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
    }
  }

  def get_all_sources() do
    HTTPoison.get!(@base_url <> "/sources", [], params: [{"apiKey", @newsapi_key}]).body
      |> Poison.decode!
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
    params = %{
      q: process_keywords(keywords),
      sources: source,
      sortBy: "relevancy",
      apiKey: @newsapi_key
    }
  end

  def retrieve_article(keywords, source) do
    HTTPoison.get!(@base_url <> "/everything", [], params: config_params(keywords, source)).body
      |> Poison.decode!
  end
end
