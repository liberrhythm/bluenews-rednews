defmodule SimilarArticleRetrieval do

  defdelegate get_all_articles(keywords), to: SimilarArticleRetrieval.Impl
  defdelegate get_all_sources(), to: SimilarArticleRetrieval.Impl

end
