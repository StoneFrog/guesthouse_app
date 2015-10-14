require './lib/common_model_functions.rb'

class Reservation < ActiveRecord::Base
  include CommonModelFunctions
  before_save :downcase_email
  before_save :convert_phone_number
  belongs_to :user
  default_scope -> { order(checkin: :asc) }
  validates :name, presence: true, length: { maximum: 50 }
  validates :surname, presence: true, length: { maximum: 75 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false}
  VALID_PHONE_REGEX = /\A\+?[\d\s\-\(\)]{7,19}\z/
  validates :phone, allow_blank: true, length: { in: 7..20 },
                    format: { with: VALID_PHONE_REGEX }
  ROOM_NUMBER_REGEX = /\A[1-5]{1}\z/ 
  validates :room, presence: true, format: { with: ROOM_NUMBER_REGEX }
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :checkin_and_checkout_date_has_to_be_free
  # add above that only where room is same as checkin room and write tests about it 

  private

    def checkin_and_checkout_date_has_to_be_free
      reservations = Reservation.where("room = ?", room)
      if are_there_any_reservations?(reservations)
        reservations.each do |reservation|
          if date_entries_not_nil?(reservation)
            unless reservations_do_not_overlap(reservation)
              errors.add(:base, 'already booked')
            end
          end
        end
      end
    end

    def are_there_any_reservations?(reservation_list)
      reservation_list.any?
    end

    def database_checkout_and_checkin_not_nil?(reservation_dates)
      !reservation_dates.checkin.nil? && !reservation_dates.checkout.nil?
    end

    def checkout_and_checkin_not_nil?
      !checkin.nil? && !checkout.nil?
    end

    def date_entries_not_nil?(reservation_dates)
      database_checkout_and_checkin_not_nil?(reservation_dates) && checkout_and_checkin_not_nil?
    end

    def does_reservation_ends_before_already_booked_stay?(reservation_dates)
      checkin < reservation_dates.checkin && checkout <= reservation_dates.checkin
    end

    def does_reservation_starts_after_already_booked_stay?(reservation_dates)
      checkin >= reservation_dates.checkout && checkout > reservation_dates.checkout
    end

    def reservations_do_not_overlap(reservation_dates)
      does_reservation_ends_before_already_booked_stay?(reservation_dates) || does_reservation_starts_after_already_booked_stay?(reservation_dates)
    end




end

#((reservation.checkin.any?) && (reservation.checkout.any?) && (checkin.any?) && (checkout.any?))
#(!(reservation.checkin.nil?) && !(reservation.checkout.nil?) && !(checkin.nil?) && !(checkout.nil?))