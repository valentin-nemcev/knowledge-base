class Article < ActiveRecord::Base

  has_many :revisions, class_name: 'ArticleRevision', dependent: :destroy
  belongs_to :current_revision, class_name: 'ArticleRevision', autosave: true
  before_destroy :unset_current_revision, prepend: true

  def unset_current_revision
    update_column(:current_revision_id, nil)
  end

  def ensure_new_revision(autosave: false)
    if current_revision.nil? || !current_revision.new_record?
      build_current_revision(article: self)
    end
  end

  def autosave(*args)
    ensure_new_revision
    update(*args)
  end

  def title
    current_revision.try!(:title)
  end

  def title=(title)
    ensure_new_revision
    current_revision.title = title
  end

  def body
    current_revision.try!(:body)
  end

  def body=(body)
    ensure_new_revision
    current_revision.body = body
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
