# frozen_string_literal: true

require "dry/monads/result"
require "dry/monads/do"

module HotelManagement
  module Types
    include Dry.Types
  end

  class CheckInGuest
    include Dry::Monads::Result::Mixin
    include Dry::Monads::Do.for(:call)

    attr_reader :room_manager

    def initialize(room_manager:)
      @room_manager = room_manager
    end

    def call(data)
      validated_data = yield validate(data)
      coerced_data = yield coerce(validated_data)
      check_in(coerced_data)
    end

    private

    def validate(data)
      check_in_hash = Types::Hash.schema(
        name: Types::String,
        rooms: Types::Coercible::Integer | Types::Array.of(Types::Coercible::Integer),
      )

      valid_data = check_in_hash[data]
      Success(valid_data)
    rescue StandardError # This is a kludge instead of specifying the myriad error types from Dry::Types
      Failure(:bad_data)
    end

    # If rooms was an integer, splat it into an array so we can iterate with it.
    def coerce(data)
      rooms_as_array = [*data[:rooms]]
      coerced_data = data.merge(rooms: rooms_as_array)
      Success(coerced_data)
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
