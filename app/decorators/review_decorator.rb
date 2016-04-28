class ReviewDecorator < Draper::Decorator
  delegate_all

  def grade_html
    self.grade.text
    # q = self.response_quality
    # q_s = Review::RESPONSE_RATINGS.fetch(q, q)

    # q_s
  end
end
