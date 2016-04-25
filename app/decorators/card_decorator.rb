class CardDecorator < Draper::Decorator
  delegate_all

  decorates_association :article

end
