require 'test_helper'

class ReservationMailerTest < ActionMailer::TestCase
  test "preliminary_reservation" do
    reservation = reservations(:first)
    mail = ReservationMailer.preliminary_reservation(reservation)
    assert_equal "Room reservation in guesthouse_name.", mail.subject
    assert_equal [reservation.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match reservation.name,               mail.body.encoded
  end

end
