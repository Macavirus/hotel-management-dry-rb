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
    def initialize
      @rooms = Set.new
    end

    def check_in_guest(name:, room:)
      @rooms << Room.new(name: name,
                         number: room)
    end

    def room_available?(room_number)
      room = @rooms.find { |r| r.number == room_number }
      room ? false : true
    end
  end
end
