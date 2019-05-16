module HotelManagement
  class CheckOutGuest
    include Dry::Monads::Result::Mixin
    include Dry::Monads::Do.for(:call)

    def initialize(room_manager:)
      @room_manager = room_manager
    end

    def call(data)
      validated_data = yield validate(data)

      check_out(validated_data)
    end

    def check_out(data)
      rooms = @room_manager.rooms_for_guest(data[:name])

      if rooms
        @room_manager.destroy(rooms)
        Success(data)
      else
        Failure(:no_such_guest)
      end
    end

    def validate(data)
      guest_hash = Types::Hash.schema(name: Types::Strict::String)
      guest_hash[data]
      Success(data)
    rescue StandardError
      Failure(:not_a_valid_name)
    end
  end
end
