class ReviewDecorator < Draper::Decorator
  delegate_all

  def response_quality_html
    q = self.response_quality
    q_s = Review::RESPONSE_RATINGS.fetch(q, q)

    q_s
  end
end
