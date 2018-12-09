defmodule SimilarArticleRetrieval do

  defdelegate get_all_articles(keywords), to: SimilarArticleRetrieval.Impl
  defdelegate get_all_sources(), to: SimilarArticleRetrieval.Impl
  defdelegate get_other_sources_map(), to: SimilarArticleRetrieval.Impl

end
