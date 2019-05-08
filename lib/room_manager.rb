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

    def rooms_for_guest(name)
      rooms = @rooms.select { |_k, v| v.name == name }

      rooms.values.any? ? rooms : nil
    end

    def destroy(rooms)
      rooms.each { |room| @rooms.delete(room) }
    end
  end
end
