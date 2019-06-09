module SoftDestruction
  extend ActiveSupport::Concern

  included do
    scope :without_soft_destroyed, -> { where(destroyed_at: nil) }

    scope :order_soft_destroyed_last, -> {
      order('destroyed_at IS NULL DESC')
    }
  end

  def soft_destroy
    touch(:destroyed_at) unless soft_destroyed?
  end

  def restore
    update_attribute(:destroyed_at, nil) if soft_destroyed?
  end

  def soft_destroyed?
    !new_record? && destroyed_at.present?
  end
end
