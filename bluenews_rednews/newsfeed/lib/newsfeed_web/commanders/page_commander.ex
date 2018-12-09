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

        articles = [
          %{
            "author" => "BENJAMIN WEISER, BEN PROTESS, MAGGIE HABERMAN and MICHAEL S. SCHMIDT",
            "bias" => :liberal,
            "content" => "In the Southern District case, Mr. Cohen already faced a potential prison sentence of about four to five years under the nonbinding federal sentencing guidelines, according to his plea agreement. It is unclear what additional time he could face with the new g… [+1159 chars]",
            "description" => "Mr. Cohen, President Trump’s former lawyer, made a surprise appearance on Thursday morning ina Manhattan courtroom to plead guilty to a new criminal charge.",
            "publishedAt" => "2018-11-29T14:09:23Z",
            "source" => %{"id" => "the-new-york-times", "name" => "The New York Times"},
            "title" => "Michael Cohen to Plead Guilty to Charge in Mueller Investigation",
            "url" => "https://www.nytimes.com/2018/11/29/nyregion/michael-cohen-trump-russia-mueller.html",
            "urlToImage" => "https://static01.nyt.com/images/2018/11/30/nyregion/30Cohenadvisory/30Cohenadvisory-facebookJumbo.jpg"
          },
          %{
            "author" => "https://www.facebook.com/bbcnews",
            "bias" => :liberal,
            "content" => "Image copyright Reuters Image caption Michael Flynn has admitted one count of lying to the FBI The office investigating Russian collusion in the US election has recommended that ex-national security adviser Michael Flynn should not have to serve a jail senten… [+1071 chars]",
            "description" => "Michael Flynn admitted lying to the FBI but has assisted in its investigation into Russian collusion.",
            "publishedAt" => "2018-12-05T01:59:45Z",
            "source" => %{"id" => "bbc-news", "name" => "BBC News"},
            "title" => "Mueller investigation: No jail time sought for Trump ex-adviser Michael Flynn",
            "url" => "https://www.bbc.co.uk/news/world-us-canada-46449950",
            "urlToImage" => "https://ichef.bbci.co.uk/news/1024/branded_news/DAE0/production/_104623065_mediaitem104622450.jpg"
          },
          %{
            "author" => "S.V. Date",
            "bias" => :liberal,
            "content" => "WASHINGTON — Donald Trump’s former personal lawyer and fixer Michael Cohen pleaded guilty on Thursday to lying to key congressional intelligence committees to help his ex-boss, but even worse news for the president is now just five weeks away. Come Jan. 3, th… [+5622 chars]",
            "description" => "The panel under Republican control has been helping Trump undermine the Mueller investigation. That’s about to change as Democrats are poised to take control of the chamber.",
            "publishedAt" => "2018-11-29T23:38:10Z",
            "source" => %{
              "id" => "the-huffington-post",
              "name" => "The Huffington Post"
            },
            "title" => "If Trump Thinks Cohen’s Plea Is Bad, Wait Til Dems Run The House Intel Committee",
            "url" => "https://www.huffingtonpost.com/entry/trump-michael-cohen-robert-mueller_us_5c006212e4b0249dce732a0f",
            "urlToImage" => "https://img.huffingtonpost.com/asset/5c0062741f00003606263b54.jpeg?cache=baxjraINIW&ops=1200_630"
          },
          %{
            "author" => "coprysko@politico.com (Caitlin Oprysko)",
            "bias" => :liberal,
            "content" => "President Donald Trump declined to say whether he would fire Deputy Attorney General Rod Rosenstein, though the deputy attorney general offered the president his resignation in September. | Pool-Oliver Contreras/Getty Images President Donald Trump defended hi… [+2679 chars]",
            "description" => "Rosenstein is responsible for picking Mueller to lead an investigation into Russian interference in the 2016 election.",
            "publishedAt" => "2018-11-29T11:57:13Z",
            "source" => %{"id" => "politico", "name" => "Politico"},
            "title" => "Trump: Rosenstein belongs in jail because 'he never should have picked a special counsel'",
            "url" => "https://www.politico.com/story/2018/11/29/trump-rosenstein-belongs-in-jail-1026104",
            "urlToImage" => "https://static.politico.com/68/7e/903d0e7b41598ffb20308e18b4c6/181129-donald-trump-gty-773.jpg"
          },
          %{
            "author" => "MSNBC.com",
            "bias" => :liberal,
            "content" => nil,
            "description" => "A source tells NBC News that President Trump will be submitting written answers to the Special Counsel this week, but a sit-down interview with Mueller? That's where the president seems to be drawing a line. Former Senior FBI Official Frank Figliuzzi, former …",
            "publishedAt" => "2018-11-19T15:12:30Z",
            "source" => %{"id" => "msnbc", "name" => "MSNBC"},
            "title" => "What happens next in the Mueller investigation?",
            "url" => "https://www.msnbc.com/hallie-jackson/watch/what-happens-next-in-the-mueller-investigation-1374749763981",
            "urlToImage" => "https://media1.s-nbcnews.com/j/MSNBC/Components/Video/201811/n_hallie_mueller_181119_1920x1080.1200;630;7;70;5.jpg"
          },
          %{
            "author" => "Patrick J. Buchanan",
            "bias" => :conservative,
            "content" => "The war in Washington will not end until the presidency of Donald Trump ends. Everyone seems to sense that now. This is a fight to the finish. A post-election truce that began with Trump congratulating House Minority Leader Nancy Pelosi—“I give her a great de… [+4882 chars]",
            "description" => "The war in Washington will not end until the presidency of Donald Trump ends. We know that now.",
            "publishedAt" => "2018-11-09T03:25:07Z",
            "source" => %{
              "id" => "the-american-conservative",
              "name" => "The American Conservative"
            },
            "title" => "This Is a Fight to the Finish",
            "url" => "https://www.theamericanconservative.com/buchanan/this-is-a-fight-to-the-finish/",
            "urlToImage" => "https://www.theamericanconservative.com/wp-content/uploads/2018/04/33128556761_d2d3010afd_z.jpg"
          },
          %{
            "author" => "David Bossie and Corey Lewandowski",
            "bias" => :conservative,
            "content" => "When the Mueller report is finally released—if it ever is released—the Fake News will crawl over it like ants at a picnic. But the one angle they won’t write about is how the deep state played them like a fiddle. The trick is called “circular sourcing,” and t… [+4687 chars]",
            "description" => "Fox News David Bossie and Corey Lewandowski: This is how the Deep State is undermining President Trump Fox News When the Mueller report is finally released—if it ever is released—the Fake News will crawl over it like ants at a picnic. But the one angle they w…",
            "publishedAt" => "2018-11-27T16:18:03Z",
            "source" => %{"id" => "fox-news", "name" => "Fox News"},
            "title" => "David Bossie and Corey Lewandowski: This is how the Deep State is undermining President Trump - FoxNews",
            "url" => "https://www.foxnews.com/opinion/david-bossie-and-corey-lewandowski-this-is-how-the-deep-state-is-undermining-president-trump",
            "urlToImage" => "https://static.foxnews.com/foxnews.com/content/uploads/2018/11/Trump112718.jpg"
          },
          %{
            "author" => "Mark Penn, opinion contributor",
            "bias" => :conservative,
            "content" => "Either Robert Mueller Robert Swan Mueller Sasse: US should applaud choice of Mueller to lead Russia probe MORE has the case of the century, tons of incriminating email and is now close to unveiling the collusion with the Russians that has been so widely repea… [+10523 chars]",
            "description" => "The Hill Is Mueller team bludgeoning to get narrative it wants? The Hill Either Robert Mueller · Robert Swan MuellerSasse: US should applaud choice of Mueller to lead Russia probe MORE has the case of the century, tons of incriminating email and is now close …",
            "publishedAt" => "2018-11-29T15:47:27Z",
            "source" => %{"id" => "the-hill", "name" => "The Hill"},
            "title" => "Is Mueller team bludgeoning to get narrative it wants? - The Hill",
            "url" => "https://thehill.com/opinion/judiciary/418879-is-mueller-team-bludgeoning-to-get-narrative-it-wants",
            "urlToImage" => "https://thehill.com/sites/default/files/muellerrobert_031319upi.jpg"
          },
          %{
            "author" => "Mairead McArdle",
            "bias" => :conservative,
            "content" => "Former FBI director James Comey at George Washington University in Washington, D.C., April 30, 2018. (Jonathan Ernst/REUTERS) Former FBI director James Comey will reportedly testify to Congress in a closed-door hearing on Friday. The news comes after months o… [+2384 chars]",
            "description" => "National Review Comey Scheduled to Testify to Congress on Friday National Review Former FBI director James Comey will reportedly testify to Congress in a closed-door hearing on Friday. The news comes after months of back-and-forth between Comey and the House …",
            "publishedAt" => "2018-12-03T21:13:00Z",
            "source" => %{"id" => "national-review", "name" => "National Review"},
            "title" => "Comey Scheduled to Testify to Congress on Friday - National Review",
            "url" => "https://www.nationalreview.com/news/comey-scheduled-to-testify-to-congress-on-friday/",
            "urlToImage" => "https://i1.wp.com/www.nationalreview.com/wp-content/uploads/2018/12/james-comey.jpg?fit=1200%2C700&ssl=1"
          },
          %{
            "author" => "Vivian Salama",
            "bias" => :conservative,
            "content" => "WASHINGTONPresident Trump asserted on Thursday that Special Counsel Robert Muellers investigationinto Russian interference in the 2016 presidential election is in complete disarray and a disgrace to our Nation, while adding that his White House is operating … [+4879 chars]",
            "description" => "Wall Street Journal Trump Castigates Mueller Investigation as 'Disgrace to Nation,' Says Probe Is 'Total Mess' Wall Street Journal WASHINGTON—President Trump asserted on Thursday that Special Counsel Robert Mueller's investigation into Russian interference in…",
            "publishedAt" => "2018-11-15T14:31:33Z",
            "source" => %{
              "id" => "the-wall-street-journal",
              "name" => "The Wall Street Journal"
            },
            "title" => "Trump Castigates Mueller Investigation as 'Disgrace to Nation,' Says Probe Is 'Total Mess' - Wall Street Journal",
            "url" => "https://www.wsj.com/articles/trump-castigates-mueller-investigation-as-disgrace-to-nation-says-probe-is-total-mess-1542292248",
            "urlToImage" => "https://images.wsj.net/im-37214/social"
          }
        ]

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

