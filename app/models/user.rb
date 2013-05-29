# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  avatar_url      :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  before_save :create_avatar_url
  before_validation :prep_email
  attr_accessible :avatar_url, :email, :name, :password, :password_confirmation, :username

  has_many :ribbits
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "followed_id"
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :followers, through: :follower_relationships
  has_many :followeds, :through => :followed_relationships

  has_secure_password
  validates :name, presence: true
  validates :username, uniqueness: true,
                       presence: true

  email_regex =  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, uniqueness: true,
                    presence: true,
                    format: { with: email_regex }

  validates :password, confirmation: true,
                       presence: true

  def following?(user)
    self.followeds.include?(user)
  end

  def follow(user)
    Relationship.create(:follower_id => self.id, :followed_id => user.id)
  end

  private

    def prep_email
      self.email = self.email.strip.downcase if self.email
    end

    def create_avatar_url
      self.avatar_url = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}?s=50"
    end

end
