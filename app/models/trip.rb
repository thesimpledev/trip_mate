# == Schema Information
#
# Table name: trips
#
#  id         :bigint           not null, primary key
#  start_date :date             not null
#  end_date   :date             not null
#  title      :string           not null
#  location   :string
#  creator_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  spaces     :integer          not null
#  privacy    :integer          default("visible"), not null
#  details    :text             default(""), not null
#
# Indexes
#
#  index_trips_on_creator_id  (creator_id)
#  index_trips_on_privacy     (privacy)
#  index_trips_on_title       (title)
#

class Trip < ApplicationRecord
  PRIVACIES = %w(visible hidden).freeze

  default_scope { order(:start_date) }
  scope :visible, -> { where(privacy: "visible") }
  scope :hidden, -> { where(privacy: "hidden") }

  belongs_to :creator, class_name: :User
  has_one_attached :cover_photo
  has_many :attend_requests, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :messages, dependent: :destroy

  enum privacy: PRIVACIES

  validates :end_date,
    :location,
    :privacy,
    :spaces,
    :start_date,
    :title,
    presence: true
  validates :details, presence: true
  validates :privacy, inclusion: { in: PRIVACIES }
  validate :valid_date_range
  validate :positive_or_unlimited_spaces
  validate :space_is_big_enough_for_attendees, on: :update

  def self.before(date)
    Trip.where("start_date < ?", date.to_date)
  end

  def self.after(date)
    Trip.where("start_date >= ?", date.to_date)
  end

  def duration
    (end_date - start_date).round + 1
  end

  def at_capacity?
    spaces_left == 0
  end

  def attend_request_for_user(user)
    attend_requests.find_by(user: user)
  end

  def attendance_for_user(user)
    attendances.find_by(user: user)
  end

  def spaces_left
    spaces - attendances.count
  end

  private

  def valid_date_range
    return if [start_date, end_date].any?(&:nil?)

    if start_date > end_date
      errors.add(:start_date, "must be before or the same as end date.")
    end
  end

  def positive_or_unlimited_spaces
    return unless spaces

    unless spaces == -1 || spaces >= 0
      errors.add(:spaces, "must be positive") if spaces&.negative?
    end
  end

  def space_is_big_enough_for_attendees
    count = attendances.count
    if count > spaces && spaces != -1
      errors.add(:spaces, "must be at least at least #{count} to fit attendees")
    end
  end
end
