defmodule SimilarArticleRetrieval.NewsAPIWrapper.Impl do
  use HTTPoison.Base

  @base_url "https://newsapi.org/v2/"
  @newsapi_key Application.get_env(:similar_article_retrieval, :newsapi_key)

  def process_request_url(endpoint) do
    @base_url <> endpoint
  end
end
