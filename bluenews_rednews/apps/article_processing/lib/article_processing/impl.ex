defmodule ArticleProcessing.Impl do
  @moduledoc """
  Documentation for ArticleProcessing.Impl.
  """

  @doc """
  Takes a URL and returns relevant article information and keywords.

  ## Examples

      iex> ArticleProcessing.Impl.process_article("https://www.wsj.com/articles/trump-forged-his-ideas-on-trade-in-the-1980sand-never-deviated-1542304508?mod=hp_lead_pos5")
      %ArticleProcessing{
        article_info: %{
          description: "The president has been consistent on trade for decades, unlike on other issues,both in tone and substance. Longtime acquaintances say his philosophy came out of his experience in the cutthroat world of New York real estate and the rise of Japan as a global economic power.",
          image: "https://images.wsj.net/im-37064/social",
          title: "Trump Forged His Ideas on Trade in the 1980s—and Never Deviated"
        },
        keywords: ["estate", "experience", "japan", "longtime", "philosophy", "president", "rise", "tone", "world", "york", "deviatedtrump", "ideas", "trade"]
      }

  """

  defstruct article_info: %{}, keywords: []

  def process_article(article) do
    results = scrape_article(article)

    %ArticleProcessing.Impl{}
      |> extract_info(results)
      |> extract_keywords(results)
  end

  defp scrape_article(article) do
    Scrape.article(article)
  end

  defp extract_info(state, results) do
    article_info = %{}
      |> Map.put(:title, results.title)
      |> Map.put(:description, results.description)
      |> Map.put(:image, results.image)

    %ArticleProcessing.Impl { state |
      article_info: article_info
    }
  end

  defp extract_keywords(state, results) do
    keywords = results.tags
      |> Enum.filter(fn tag -> tag.accuracy == 1 end)
      |> Enum.map(fn good_tag -> good_tag.name end)
      |> filter_keywords

    %ArticleProcessing.Impl { state |
      keywords: keywords
    }
  end

  defp filter_keywords(keywords) do
    keywords
      |> Enum.join(" ")
      |> Textgain.tag(lang: "en")
      |> find_nouns
  end

  defp find_nouns({:ok, textgain}) do
    textgain.text
      |> List.flatten
      |> Enum.filter(fn res -> Map.get(res, "tag") == "NOUN" end)
      |> Enum.map(fn noun -> Map.get(noun, "word") end)
  end

  # defp insert_keyword(kw, keywords) do
  #   [kw | keywords]
  # end
end