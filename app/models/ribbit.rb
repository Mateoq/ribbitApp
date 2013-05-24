# == Schema Information
#
# Table name: ribbits
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Ribbit < ActiveRecord::Base
  default_scope order: 'created_at DESC'
  attr_accessible :content, :user_id
  belongs_to :user

  validates :content, length: { maximum: 140 }
end
