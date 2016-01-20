class Article < ActiveRecord::Base
  has_many :reviews,  -> { order(:reviewed_at) }, class_name: "ArticleReview"

  def ever_reviewed?
    self.reviews.present?
  end

  def review_count
    self.reviews.count
  end

  def first_reviewed_at
    self.reviews.first.try!(:reviewed_at)
  end

  def last_reviewed_at
    self.reviews.last.try!(:reviewed_at)
  end

  def add_review(time)
    self.reviews.create(reviewed_at: time)
  end
end
