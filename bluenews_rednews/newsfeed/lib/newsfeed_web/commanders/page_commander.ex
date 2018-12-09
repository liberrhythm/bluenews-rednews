defmodule NewsfeedWeb.PageCommander do
  use Drab.Commander

  # Place your event handlers here

  defhandler button_clicked(socket, _sender) do
    query = query(socket, "#user-input", :value)
    case query do
      {:ok, _values} ->
        # user_input = values["#user-input"]["value"]

        # article = ArticleProcessing.process_article(user_input)

        # IO.inspect article.keywords
        keywords = ["investigation", "fbi", "mueller"]
        IO.inspect SimilarArticleRetrieval.get_all_articles(keywords)

        set_prop socket, "#output_div", innerHTML: "success"
      _ ->
        set_prop socket, "#output_div", innerHTML: "error"
    end
  end

  # Place your callbacks here

  onload :page_loaded

  def page_loaded(socket) do
    set_prop socket, "div.jumbotron h2", innerText: "This page has been drabbed"
  end
end

