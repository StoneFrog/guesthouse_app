class ReservationsController < ApplicationController

  def new
    # Default room is 1. Can be changed in the view
    new_reservation

    respond_to do |format|
      format.html 
      format.js
    end
  end

  def create
    if logged_in?
      @reservation = current_user.reservations.build(reservation_params)
    else
      @reservation = Reservation.new(reservation_params)
    end

    respond_to do |format|
      if @reservation.save
        ReservationMailer.preliminary_reservation(@reservation).deliver_now
        flash[:info] = "Reservation submitted successfuly. 
                        Please check your email for further instructions or 
                        contact us in case of problems."
        format.html 
        format.js { render js: "window.location.href='"+root_url+"'" }
      else
        format.html
        format.js
      end
    end

  end

  def edit
  end

  def update
  end

  def destroy
  end

  def room2
    new_reservation("2")

    respond_to do |format|
      format.html 
      format.js
    end
  end

  def room3
    new_reservation("3")

    respond_to do |format|
      format.html 
      format.js
    end
  end

  def room4
    new_reservation("4")

    respond_to do |format|
      format.html 
      format.js
    end
  end

  def room5
    new_reservation("5")

    respond_to do |format|
      format.html 
      format.js
    end
  end

  private

    def reservation_params
      params.require(:reservation).permit(:name, :surname, :email,
                                          :phone, :room, :checkin, 
                                          :checkout)
    end

    # Function to create new reservation to keep code DRY
    def new_reservation(room_number="1")
      if logged_in?
        @reservation = Reservation.new(name: current_user.name, 
                                     surname: current_user.surname,
                                     email: current_user.email, 
                                     phone: current_user.phone,
                                     room: room_number)
      else
        @reservation = Reservation.new(room: room_number)
      end
    end
  
end
