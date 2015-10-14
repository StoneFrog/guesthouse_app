require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  
  def setup
    @reservation = Reservation.new(name: 'User', surname: 'Example',
                                  email: 'user@example.com', phone: '+48665273066',
                                  room: '1', confirmation: false,
                                  checkin: Time.zone.now.midday.advance(months: 5, days: 5),
                                  checkout: Time.zone.now.midday.advance(months: 5, days: 10))
    @test_reservation = Reservation.new(name: 'User', surname: 'Test',
                                        email: 'test@example.com', phone: '+48665273066',
                                        room: '1', confirmation: false,
                                        checkin: Time.zone.now.midday.advance(months: 5, days: 4),
                                        checkout: Time.zone.now.midday.advance(months: 5, days: 12))
  end

  test "should be valid" do 
    assert @reservation.valid?, "#{@reservation.errors.messages}"
  end

  test "user_id is not required" do
    @reservation.user_id = nil
    assert @reservation.valid?
  end

  test "name should be present" do
    @reservation.name = ""
    assert_not @reservation.valid?
  end

  test "name can't be too long" do
    @reservation.name = "a" * 51
    assert_not @reservation.valid?
  end

  test "surname should be present" do
    @reservation.surname = ""
    assert_not @reservation.valid?
  end

  test "surname can't be too long" do
    @reservation.surname = "a" * 76
    assert_not @reservation.valid?
  end

  test "email should be present" do
    @reservation.email = ""
    assert_not @reservation.valid?
  end

  test "email can't be too long" do
    @reservation.email = "a" * 244 + "@example.com"
    assert_not @reservation.valid?
  end

  test "email validation should accept valid email address" do
    valid_addresses = %w[user@example.com USER@Foo.COM A_US-eR@foo.bar.org
                         first.last@foo.jp alce+boob@baz.ch]
    valid_addresses.each do |valid_address|
      @reservation.email = valid_address
      assert @reservation.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid email address" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..biz]
    invalid_addresses.each do |invalid_address|
      @reservation.email = invalid_address
      assert_not @reservation.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be downcased" do 
    mixed_case_email = "UsEr@ExAMPLe.CoM"
    @reservation.email = mixed_case_email
    @reservation.save
    assert_equal mixed_case_email.downcase, @reservation.reload.email
  end

  test "phone can't be neither too short nor too long" do
    @reservation.phone = "a" * 21
    assert_not @reservation.valid?
    @reservation.phone = "a" * 6
    assert_not @reservation.valid?
  end

  test "phone validation should accept valid phone number" do
    valid_numbers = ["+48 665 273 066", "+48 (505) 5454545 5", "42 671 91 36",
                      "00 420 623 623 623", "42 631-31-31"]
    valid_numbers.each do |valid_number|
      @reservation.phone = valid_number
      assert @reservation.valid?, "#{valid_number.inspect} should be valid"
    end
  end

  test "phone validation should not accept invalid phone number" do
    invalid_numbers = ["+48 665 273/066", "(665)x062 565 48", "4AS 671 91 36",
                      "00*420 623 623 623"]
    invalid_numbers.each do |invalid_number|
      @reservation.phone = invalid_number
      assert_not @reservation.valid?, "#{invalid_number.inspect} should be invalid"
    end
  end

  test "phone should be standardized" do
    idiotic_phone_numbers = ["+ 69 5-595-595", "+48 (505) 5454545 5"]
    idiotic_phone_numbers.each do |idiotic_phone_number|
      @reservation.update_attribute(:phone, convert_phone_number(idiotic_phone_number))
      assert_equal idiotic_phone_number.tr('\ \-', ""), @reservation.reload.phone
    end
  end

  test "room should be present" do
    @reservation.room = ''
    assert_not @reservation.valid?
  end

  test "room validation should not accept invalid room number" do
    invalid_rooms = %w[15 0 11 152 a5 d3]
    invalid_rooms.each do |invalid_room|
      @reservation.room = invalid_room
      assert_not @reservation.valid?, "#{invalid_room.inspect} should be invalid"
    end
  end

  test "room validation should accept valid room number" do
    valid_rooms = %w[1 2 3]
    valid_rooms.each do |valid_room|
      @reservation.room = valid_room
      assert @reservation.valid?, "#{valid_room.inspect} should be valid"
    end
  end

  test "checkin should be present" do
    @reservation.checkin = nil
    assert_not @reservation.valid?
  end

  test "checkout should be present" do
    @reservation.checkout = nil
    assert_not @reservation.valid?
  end

  test "order should be soonest reservation first" do
    assert_equal reservations(:first), Reservation.first
  end

  test "if checkin is between pre-booked dates it should not be valid" do
    @reservation.save
    @test_reservation.checkin = @reservation.checkin.advance(days: 1)
    assert_not @test_reservation.valid?
  end

  test "if checkout is between pre-booked dates it should not be valid" do
    @reservation.save
    @test_reservation.checkout = @reservation.checkout.advance(days: -1)
    assert_not @test_reservation.valid?
  end

  test "if checkout and checkin are between pre-booked dates it should not be valid" do
    @reservation.save
    @test_reservation.checkout = @reservation.checkout.advance(days: -1)
    @test_reservation.checkin = @reservation.checkin.advance(days: 1)
    assert_not @test_reservation.valid?
  end

  test "if pre-booked dates are between checkin checkout should not be valid" do
    @reservation.save
    @test_reservation.checkout = @reservation.checkout.advance(days: 1)
    @test_reservation.checkin = @reservation.checkin.advance(days: -1)
    assert_not @test_reservation.valid?
  end

  test "if booked in free time should be valid" do
    @reservation.save
    @test_reservation.checkin = @reservation.checkout.advance(days: 1)
    @test_reservation.checkout = @test_reservation.checkin.advance(days: 3)    
    assert @test_reservation.valid?
  end

  test "checkout of already booked stay may be the same as checkin of new reservation" do 
    @reservation.save
    @test_reservation.checkin = @reservation.checkout
    @test_reservation.checkout = @test_reservation.checkin.advance(days: 3)    
    assert @test_reservation.valid?
  end

  test "checkout of new reservation may be the same as checkin of already booked stay" do 
    @reservation.save
    @test_reservation.checkout = @reservation.checkin
    @test_reservation.checkin = @test_reservation.checkout.advance(days: -3)   
    assert @test_reservation.valid?
  end

  test "for different rooms reservation time should not interfere" do 
    @reservation.save
    assert_not @test_reservation.valid?
    @test_reservation.room = "2"
    assert @test_reservation.valid?
  end

end
