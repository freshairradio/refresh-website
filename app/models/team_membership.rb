class TeamMembership < ApplicationRecord

  after_initialize :default_to_non_manager

  belongs_to :user
  belongs_to :team

  validates_presence_of :user_id, :team_id
  validates_uniqueness_of :user_id, :scope => :team_id

  private

    def default_to_non_manager
      self.is_manager = false if self.is_manager.nil?
    end

end
