require "dry/monads/result"
require "set"
require "pry"

module HotelManagement
  class Room
    attr_reader :number, :name

    def initialize(name:, number:)
      @name = name
      @number = number
    end
  end

  class Hotel
    include Dry::Monads::Result::Mixin

    def initialize
      @rooms = Set.new
    end

    # Check in a guest
    #
    # @param name [String] The name of the guest checking in
    # @param rooms [Integer, Array<Integer>] The room number to check in
    # @return [Array<Dry::Monads::Result>] an array of Success || Failure objects
    def check_in_guest(name:, rooms:)
      # Coerce an Integer to an Array
      rooms = [*rooms]

      # Logic Error, it could check in a few rooms, and fail the last one. If not all are available, we shouldn't check in a few
      check_ins = rooms.map do |room|
        if room_available?(room)
          new_room = Room.new(name: name,
                              number: room)
          @rooms << new_room

          Success(new_room)
        else
          Failure(:room_not_available)
        end
      end

      check_ins.all?(Success) ? [Success()] : [Failure(:room_not_available)]
    end

    def check_out_guest(name:)
      guest_rooms = @rooms.select { |r| r.name == name }
      if guest_rooms.any?
        guest_rooms.each { |room| @rooms.delete(room) }
      else
        Failure(:no_such_guest)
      end
    end

    def room_available?(room_number)
      room = @rooms.find { |r| r.number == room_number }
      room ? false : true
    end
  end
end
