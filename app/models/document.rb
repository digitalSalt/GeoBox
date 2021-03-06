class Document < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  validates_uniqueness_of :filename, scope: :user
  validates :filename, :attachment, :user, :description, :latitude, :longitude, presence: true
  mount_uploader :attachment, AttachmentUploader
end
