
module HotelManagement
  RSpec.describe Hotel do
    describe "checking in a guest" do
    end

    describe "#room_available?" do
      it "returns false if room is taken" do
        hotel = Hotel.new
        hotel.check_in_guest(name: "Name",
                             room: 405)
        expect(hotel.room_available?(405)).to be(false)
      end

      it "returns true if room is available" do
        hotel = Hotel.new
        expect(hotel.room_available?(405)).to be(true)
      end
    end
  end
end
