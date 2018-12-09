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
        articles = SimilarArticleRetrieval.get_all_articles(keywords)

        # liberal_articles = Enum.filter(articles, fn art -> art["bias"] == :liberal end)
        # conservative_articles = Enum.filter(articles, fn art -> art["bias"] == :conservative end)

        # put_store(socket, :liberal_articles, liberal_articles)
        # put_store(socket, :conservative_articles, conservative_articles)

        # poke(socket, "index.html", liberal_articles: liberal_articles)
        # poke(socket, "index.html", conservative_articles: conservative_articles)

        articles = [%{
          "author" => "MSNBC.com",
          "bias" => :liberal,
          "content" => nil,
          "description" => "An in-depth New York Times article lays out new allegations against Facebook, claiming it ignored and concealed signs of Russian election interference. Stephanie Ruhle is joined by Recode Editor-at-Large Kara Swisher to discuss this controversy and what it me…",
          "publishedAt" => "2018-11-15T19:20:26Z",
          "source" => %{"id" => "msnbc", "name" => "MSNBC"},
          "title" => "Kara Swisher: Everyone is going to drop a dime on Facebook now",
          "url" => "https://www.msnbc.com/velshi-ruhle/watch/facebook-concealed-signs-of-russian-election-interference-1371618371970",
          "urlToImage" => "https://media1.s-nbcnews.com/j/MSNBC/Components/Video/201811/n_vr_kara_181115_1920x1080.1200;630;7;70;5.jpg"
        },
        %{
          "author" => "Rod Dreher",
          "bias" => :conservative,
          "content" => "Today (Thursday November 15) in the US Senate (Hart Room 902), The American Conservative hosts a foreign policy conference that has an incredible line-up of speakers, including includes Senator Rand Paul, Michael Anton, Col. Douglas Macgregor, Dan McCarthy, H… [+2835 chars]",
          "description" => "Sen. Rand Paul and others in all-day event -- livestreamed on this website",
          "publishedAt" => "2018-11-15T13:20:14Z",
          "source" => %{
            "id" => "the-american-conservative",
            "name" => "The American Conservative"
          },
          "title" => "TAC’s Foreign Policy Conference TODAY",
          "url" => "https://www.theamericanconservative.com/dreher/tac-foreign-policy-conference/",
          "urlToImage" => "http://www.theamericanconservative.com/wp-content/uploads/2018/11/shutterstock_294302615.jpg"
        }]

        liberal_articles = Enum.filter(articles, fn art -> art["bias"] == :liberal end)
        conservative_articles = Enum.filter(articles, fn art -> art["bias"] == :conservative end)

        poke(socket, "index.html", liberal_articles: liberal_articles)
        poke(socket, "index.html", conservative_articles: conservative_articles)

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

