defmodule ArticleProcessing do

  defdelegate process_article(article), to: ArticleProcessing.Impl

end
