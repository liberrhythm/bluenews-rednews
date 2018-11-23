defmodule SimilarArticleRetrieval.Impl do

  @news_sources []

  def retrieve_article(news_src) do
    Application.get_env(:similar_article_retrieval, :newsapi_key)
  end

end
