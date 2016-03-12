class Revision < ActiveRecord::Base
  belongs_to :article, inverse_of: :revisions
end
