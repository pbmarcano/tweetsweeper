class DeleteTweetJob < ApplicationJob
  queue_as :default

  # retry on errors... see if this stops them from getting logged
  retry_on HTTP::ConnectionError
  retry_on ActiveJob::DeserializationError
  retry_on Twitter::Error::InternalServerError
  retry_on Twitter::Error::ServiceUnavailable, wait: :exponentially_longer

  def perform(tweet)
    @tweet = tweet

    delete_from_twitter
    @tweet.destroy

    Ahoy::Tracker.new(user: @tweet.user).track("deleted tweet", @tweet)
  end

  private

  def delete_from_twitter
    client.destroy_status(@tweet.tweet_id)
  rescue Twitter::Error::NotFound # Tweet was deleted elsewhere
    return nil
  rescue Twitter::Error::Forbidden # Retweeted thing is blocked or hidden
    return nil
  end

  def client
    @client ||= @tweet.user.twitter
  end
end
