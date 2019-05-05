require "dry/monads/result"
require "set"
require "pry"

module HotelManagement
  class Room
    attr_reader :number

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

    def check_in_guest(name:, room:)
      if room_available?(room)
        new_room = Room.new(name: name,
                            number: room)
        @rooms << new_room
        Success(new_room)
      else
        Failure(:room_not_available)
      end
    end

    def room_available?(room_number)
      room = @rooms.find { |r| r.number == room_number }
      room ? false : true
    end
  end
end
