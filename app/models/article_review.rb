class ArticleReview < ActiveRecord::Base
  belongs_to :article

  validates :response_quality,
    inclusion: { in: (0..5),
                 message: "%{value} must be integer in [0, 5]" }

  def update_prev_reviews(prev)
    @prev_reviews = prev
  end

  def prev_reviews
    article.update_prev_reviews(self) if @prev_reviews.nil?
    @prev_reviews
  end

  def next_interval
    return nil unless valid?
    if prev_reviews.empty? || response_quality < 3
      1.day
    elsif last_interval < 6.days
      6.days
    else
      last_interval * e_factor
    end
  end

  def next_at
    next_interval.present? ? (reviewed_at + next_interval) : nil
  end

  def last_interval
    self.reviewed_at - prev_reviews.last.reviewed_at
  end

  def e_factor
    return nil unless valid?
    prev_reviews.reduce(2.5) do |ef, review|
      q = review.response_quality
      next if q.nil?
      ef = ef + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
      [ef, 1.3].max
    end
  end
end
