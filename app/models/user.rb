class User < ApplicationRecord

  validates_presence_of :first_name, :last_name

  rolify

  has_many :show_memberships, dependent: :delete_all
  has_many :shows, through: :show_memberships

  has_many :team_memberships, dependent: :delete_all
  has_many :teams, through: :team_memberships

  has_many :bookings, dependent: :delete_all

  has_many :podcasts, through: :shows
  has_many :show_posts, through: :shows, source: :posts
  has_many :posts, class_name: 'Post', foreign_key: 'author_id'

  accepts_nested_attributes_for :show_memberships, :allow_destroy => true
  accepts_nested_attributes_for :team_memberships, :allow_destroy => true

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :timeoutable, :lockable

  scope :to_approve, -> { where(approved: false) }
  scope :valid, -> { where("approved = ? AND confirmed_at IS NOT NULL", true ) }
  scope :by_first_name, -> { order(:first_name) }

  def name
    "#{first_name} #{last_name}"
  end

  def to_s
    name
  end

  # https://github.com/plataformatec/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

end
