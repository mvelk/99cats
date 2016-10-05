# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Cat < ActiveRecord::Base
  CAT_COLORS = %w(brown black grey orange white)
  validates :birth_date, :name, :sex, presence: true
  validates :color, inclusion: { in: CAT_COLORS}

  has_many :cat_rental_requests,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :CatRentalRequest,
  dependent: :destroy

  def cat_colors
    CAT_COLORS
  end

  def age
    now = Date.today
    age = now.year - birth_date.year
    age
  end
end
