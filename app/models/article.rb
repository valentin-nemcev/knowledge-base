class Article < ActiveRecord::Base

  has_many :revisions, class_name: 'ArticleRevision', dependent: :destroy
  belongs_to :current_revision, class_name: 'ArticleRevision'

  def title
    current_revision.try!(:title)
  end

  def body
    current_revision.try!(:body)
  end


  has_many :reviews,  -> { order(:reviewed_at) },
    class_name: 'ArticleReview', dependent: :destroy

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
