module HotelManagement
  class RoomManager
    def initialize
      @rooms = {}
    end

    def add_room(room)
      @rooms[room.number] = room
    end

    def room_available?(room_number)
      room = @rooms.keys.find { |r| r == room_number }
      room ? false : true
    end
  end
end
