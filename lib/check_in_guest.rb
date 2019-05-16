# frozen_string_literal: true

# A service object to check in a guest. The entire data flow is listed in the public #call method.

require "dry/monads/result"
require "dry/monads/do"

module HotelManagement
  module Types
    include Dry.Types
  end

  class CheckInGuest
    include Dry::Monads::Result::Mixin
    include Dry::Monads::Do.for(:call)

    def initialize(room_manager:)
      @room_manager = room_manager
    end

    def call(data)
      validated_data = yield validate(data)
      duplicates_removed = yield remove_duplicates(validated_data)
      check_in(duplicates_removed)
    end

    private

    CHECK_IN_HASH = Types::Hash.schema(
      name: Types::Coercible::String,
      rooms: Types::Coercible::Integer | Types::Array.of(Types::Coercible::Integer),
    )

    def validate(data)
      valid_types = CHECK_IN_HASH[data]

      # If rooms was an integer, splat it into an array so we can iterate with it.
      coerced = valid_types.merge(rooms: Array(valid_types[:rooms]))

      Success(coerced)
    rescue StandardError # This is a kludge instead of specifying the myriad error types from Dry::Types
      Failure(:bad_data)
    end

    def remove_duplicates(data)
      if data[:rooms].group_by(&:itself).select { |_k, v| v.size > 1 }.keys.empty?
        Success(data)
      else
        Failure(:duplicate_rooms)
      end
    end

    def check_in(data)
      rooms = data[:rooms]
      name = data[:name]

      if rooms.all? { |room| @room_manager.room_available?(room) }
        room_list = rooms.map do |r|
          @room_manager.add_room(Room.new(name: name, number: r))
        end

        Success(room_list)
      else
        Failure(:rooms_not_available)
      end
    end
  end
end
