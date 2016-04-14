class Card < ActiveRecord::Base
  belongs_to :article, inverse_of: :cards

  def body_html
    super.html_safe
  end
end
