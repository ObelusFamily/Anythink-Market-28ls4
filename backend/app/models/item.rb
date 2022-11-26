# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  before_create :image_nil

  scope :sellered_by, ->(username) { where(user: User.where(username: username)) }
  scope :favorited_by, ->(username) { joins(:favorites).where(favorites: { user: User.where(username: username) }) }

  acts_as_taggable

  validates :title, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :slug, uniqueness: true, exclusion: { in: ['feed'] }

  def image_nil
      self.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'placeholder.png')), filename: 'placeholder.png', content_type: 'image/png')
    end
  end

  before_validation do
    self.slug ||= "#{title.to_s.parameterize}-#{rand(36**6).to_s(36)}"
  end
end
