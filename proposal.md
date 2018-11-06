Name: Sabrina Peng          ID: 42712232

## Proposed Project

The bilateral nature of the current US political atmosphere means that most Americans tend to categorize their political beliefs on a spectrum, ranging from the liberal left to the conservative right. Most of these people gain information on current political events from news sources whose biases align with their own beliefs. My Phoenix web app, loosely based off of *Blue Feed, Red Feed* by the Wall Street Journal[1], is meant to provide a side by side comparison of news articles that have different perspectives on user-specified issues. Users will input a URL link to a news article and will be shown a variety of topically similar articles from predetermined liberal and conservative news outlets.

## Outline Structure

The app will take user input in the form of a URL link to a news article and scrape the article's contents for keywords and topics using a natural language processing library called *textgain*[2]. Once the app has a list of keywords, it will query endpoints on *News API*[3] and return the top related news article for each of 6-10 different news sources (half liberal and half conservative). 

For each news source, my News API query supervisor will spawn a worker that hits its specified endpoint and returns that news article, enabling all requests to be done concurrently. The restart option should be :transient so that children will not be restarted if the News API fails to return a valid article (in that case, the app would not display an article for that news source), but will be restarted in the case of abnormal errors and try to pull the data again. The supervisor strategy would be :one_for_one because pulling data from one news source should not affect the same process for another news source. No additional framework would be needed to implement this functionality.

My project will have one module that defines the functionality for scraping the user-input article and conducting NLP processing in order to generate a list of keywords. Another separate module will handle the API querying and returning of article data. I'm also thinking of doing some sort of sentiment/polarity analysis to display some political bias statistics for the corpus of articles returned, as an added bonus to the project.

[1] http://graphics.wsj.com/blue-feed-red-feed/
[2] https://github.com/arpieb/textgain
[3] https://newsapi.org/