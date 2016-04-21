module Revisions
  extend ActiveSupport::Concern

  included do
    revision_class_name = name + 'Revision'
    const_set :RevisionClass, revision_class_name.constantize

    has_many :revisions, -> { order(:created_at) },
      class_name: revision_class_name,
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
      class_name: revision_class_name, autosave: true
    before_destroy :unset_current_revision, prepend: true
  end

  def unset_current_revision
    update_column(:current_revision_id, nil)
  end

  def save_revision(autosave:, attributes:)
    if current_revision.try!(:autosave?)
      current_revision.update(attributes)
    else
      new_revision = self.class::RevisionClass.new(attributes)

      if new_revision.different_from?(current_revision)
        self.current_revision = new_revision
        self.revisions.add_without_saving(new_revision)
      end
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

  module Revision
    def different_from?(other)
      other.nil? ||
        other.slice(*revision_attributes) != self.slice(*revision_attributes)
    end

    # e.g. ArticleRevision#article, CardRevision#card, etc
    def revision_parent
      association(self.class.reflections
                    .find{ |name, r| r.inverse_of.name == :revisions }
                    .first).reader
    end

    def current_revision?
      revision_parent.current_revision == self
    end
  end
end
