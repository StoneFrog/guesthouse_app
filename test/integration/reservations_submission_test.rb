require 'test_helper'

class ReservationsSubmissionTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid reservation information" do 
    get new_reservation_path
    assert_no_difference "Reservation.count" do
      post reservations_path, format: :js, reservation: { name: "",
                                             surname: "",
                                             email: "user@invalid",
                                             phone: "666x",
                                             room: "6",
                                             checkin: "16062015",
                                             checkout: "15062015"} 
    end
    assert_template partial: 'shared/_reservations_error_messages', count: 1
    assert_template partial: 'reservations/_reservation_form', count: 1
    assert_equal "text/javascript", @response.content_type
    assert_match 'error_explanation', response.body
    assert_match "alert-danger", response.body
  end

  test "valid reservation submission" do
    get new_reservation_path
    assert_difference 'Reservation.count', 1 do
      post reservations_path, format: :js, reservation: { name: "Example",
                                             surname: "User",
                                             email: "user@valid.com",
                                             phone: "666666666",
                                             room: "1",
                                             checkin: "16 February2016",
                                             checkout: "19 February 2016"} 
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal "text/javascript", @response.content_type
    assert_equal "Reservation submitted successfuly. 
                        Please check your email for further instructions or 
                        contact us in case of problems.", flash[:info]
    assert_match "window.location.href", response.body
  end


end
