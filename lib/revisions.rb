module Revisions
  extend ActiveSupport::Concern

  included do
    REVISION_CLASS_NAME = name + 'Revision'
    RevisionClass = REVISION_CLASS_NAME.constantize

    has_many :revisions, -> { order(:created_at) },
      class_name: REVISION_CLASS_NAME,
      dependent: :destroy,
      inverse_of: name.underscore.to_sym do
        def add_without_saving(record)
          # http://stackoverflow.com/questions/13197359/add-association-without-commiting-to-database
          proxy_association.add_to_target(record)
          inverse_of = proxy_association.reflection.inverse_of
          record.association(inverse_of.name).replace proxy_association.owner
        end

        def duplicated_chunks
          chunk_while(&:different_from?).select(&:many?)
        end
      end
    belongs_to :current_revision,
      class_name: REVISION_CLASS_NAME, autosave: true
    before_destroy :unset_current_revision, prepend: true
  end

  def unset_current_revision
    update_column(:current_revision_id, nil)
  end

  def save_revision(autosave:, attributes:)
    new_revision = RevisionClass.new(attributes)

    if new_revision.different_from?(current_revision)
      self.current_revision = new_revision
      self.revisions.add_without_saving(new_revision)
    end

    if current_revision.new_record? || autosave == false
      current_revision.autosave = autosave
    end

    save
  end

  def destroy_duplicated_revisions
    revisions.duplicated_chunks.each do |first, *rest|
      update!(current_revision: first) if current_revision.in? rest
      rest.each(&:destroy!)
    end
  end
end
