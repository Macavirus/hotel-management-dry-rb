module HotelManagement
  class Room
    attr_reader :number, :name

    def initialize(name:, number:)
      @name = name
      @number = number
    end
  end
end
