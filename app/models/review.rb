class Review < ActiveRecord::Base
  belongs_to :card


  # using this instead of before_create for correct ordering
  before_save :set_default_reviewed_at, :if => :new_record?
  before_save :set_calculated_attributes

  def set_default_reviewed_at
    self.reviewed_at ||= DateTime.now
    true
  end

  def set_calculated_attributes
    write_attribute(:e_factor, calculate_e_factor)
    write_attribute(:next_review_at, calculate_next_review_at)
  end

  # https://www.supermemo.com/english/ol/sm2.htm
  # http://ankisrs.net/docs/manual.html#what-spaced-repetition-algorithm-does-anki-use

  include ClassyEnum::ActiveRecord
  classy_enum_attr :grade, class_name: 'ReviewGrade'


  def prev_reviews
    card.reviews.take_while { |review| review != self }
  end

  def next_review_at
    read_attribute(:next_review_at) || calculate_next_review_at
  end

  def calculate_next_review_at
    next_interval.present? ? (reviewed_at + next_interval) : nil
  end

  def next_interval
    return nil unless valid?
    if prev_reviews.empty? || grade.again?
      1.day
    elsif last_interval < 6.days
      6.days
    else
      last_interval * e_factor
    end
  end

  def last_interval
    self.reviewed_at - prev_reviews.last.reviewed_at
  end

  def e_factor
    read_attribute(:e_factor) || calculate_e_factor
  end

  def calculate_e_factor
    return nil unless valid?
    prev_reviews.reduce(2.5) do |ef, review|
      q = review.grade.number
      return ef if q.nil?
      ef = ef + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
      [ef, 1.3].max
    end
  end
end
