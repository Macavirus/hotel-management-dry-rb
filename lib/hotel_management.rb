# frozen_string_literal: true

require "dry/monads/result"
require "dry/monads/do"
require "dry-types"
require "set"
require "pry"
require_relative "room_manager.rb"
require_relative "check_in_guest.rb"

module HotelManagement
  class Hotel
    include Dry::Monads::Result::Mixin

    def initialize
      @room_manager = RoomManager.new
    end

    # Check in a guest
    #
    # @param name [String] The name of the guest checking in
    # @param rooms [Integer, Array<Integer>] The room number(s) to check in
    # @return [Dry::Monads::Result] The Success or Failure object wrapping a rooms list or failure code
    def check_in_guest(name:, rooms:)
      CheckInGuest.new(room_manager: @room_manager).call(name: name, rooms: rooms)
    end

    def check_out_guest(name:)
      guest_rooms = @rooms.select { |r| r.name == name }
      if guest_rooms.any?
        guest_rooms.each { |room| @rooms.delete(room) }
      else
        Failure(:no_such_guest)
      end
    end
  end
end
