# Preview all emails at http://localhost:3000/rails/mailers/reservation_mailer
class ReservationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/reservation_mailer/preliminary_reservation
  def preliminary_reservation
    reservation = Reservation.first
    ReservationMailer.preliminary_reservation(reservation)
  end

end
