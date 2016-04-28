class CardDecorator < Draper::Decorator
  delegate_all

  decorates_association :article
  decorates_association :reviews

end
