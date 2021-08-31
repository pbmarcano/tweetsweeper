class FetchTweetsJob < ApplicationJob
  queue_as :default

  def perform(user)
    fetched_tweets_by(user).each do |tweet|
      make_tweet(tweet, user)
    end
  end

  private

  def make_tweet(tweet, user)
    t = Tweet.find_or_initialize_by(tweet_id: tweet.id, user: user)

    t.assign_attributes(
      published_at: tweet.created_at.to_datetime,
      full_text: tweet.full_text,
      url: tweet.url.to_s
    )

    t.save
  end

  def fetched_tweets_by(user)
    collect_with_max_id do |max_id|
      options = {count: 200, include_rts: true, id: user.uid}
      options[:max_id] = max_id unless max_id.nil?
      user.twitter.user_timeline(options)
    end
  end

  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response

    if response.empty?
      collection.flatten 
    else
      collect_with_max_id(collection, response.last.id - 1, &block)
    end
  end
end
