class ReservationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reservation_mailer.preliminary_reservation.subject
  #
  def preliminary_reservation(reservation)
    @reservation = reservation
    mail to: reservation.email, subject: "Room reservation in guesthouse_name."
  end
end
