# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatRentalRequest < ActiveRecord::Base
  STATUSES = %w(PENDING APPROVED DENIED)
  validates :status, inclusion: { in: STATUSES }
  validates :cat_id, :start_date, :end_date, presence: true
  validate :no_double_rentals

  belongs_to :cat,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :Cat

  # CatRentalRequest.transaction do
  #   approve!
  # end

  def approve!
    self.status = 'APPROVED'
    self.overlapping_pending_requests.each do |request|
      request.deny!
      request.save
    end
    self.save
  end

  def deny!
    self.status = 'DENIED'
  end

  def statuses
    STATUSES
  end

  def overlapping_requests
    self.cat.cat_rental_requests
    .where("(start_date, end_date) OVERLAPS (?, ?)", self.start_date, self.end_date)
    .where("id != ?", self.id)
  end

  def overlapping_approved_requests
    overlapping_requests.where("status = 'APPROVED'")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

  def no_double_rentals
    unless overlapping_approved_requests.empty?
      errors[:request_overlaps] << "cat already rented during this period"
    end
  end
end
