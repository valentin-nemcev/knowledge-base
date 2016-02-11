class ArticleReview < ActiveRecord::Base
  belongs_to :article

  def update_prev_reviews(prev)
    @prev_reviews = prev
  end

  def prev_reviews
    article.update_prev_reviews(self) if @prev_reviews.nil?
    @prev_reviews
  end

  def next_interval
    case prev_reviews.count
    when 0 then 1.day
    when 1 then 6.days
    else last_interval * e_factor
    end
  end

  def next_at
    (reviewed_at + next_interval).to_date
  end

  def last_interval
    self.reviewed_at - prev_reviews.last.reviewed_at
  end

  def e_factor
    prev_reviews.reduce(2.5) do |ef, review|
      q = review.response_quality
      next if q.nil?
      ef + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
    end
  end
end
