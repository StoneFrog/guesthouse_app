class ReservationsController < ApplicationController

  def new
    if logged_in?
      @reservation = Reservation.new(name: current_user.name, 
                                     surname: current_user.surname,
                                     email: current_user.email, 
                                     phone: current_user.phone)
    else
      @reservation = Reservation.new
    end
  end

  def create
    if logged_in?
      @reservation = current_user.reservations.build(reservation_params)
    else
      @reservation = Reservation.new(reservation_params)
    end
    if @reservation.save
      # not final implementation - send notification email, 
      # flash and redirect to url
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  # initial implementation to make ajax query working
  def booked_dates
    reservations = Reservation.where("room = ?", room)
    booked_dates = []
    reservations.each do |reservation|
      booked_dates.push("#{reservation.checkin}", "#{reservation.checkout}")
    end
      respond_to do |format|
      format.html
      format.js
    end
    return booked_dates
  end

  private

    #not sure if user_id should be permitted here as well. may be abused
    #to create some discounts in the future
    def reservation_params
      params.require(:reservation).permit(:name, :surname, :email,
                                          :phone, :room, :checkin, 
                                          :checkout)
    end
  
end
