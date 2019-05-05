# frozen_string_literal: true

module HotelManagement
  RSpec.describe Hotel do
    subject(:hotel) { described_class.new }

    describe "checking in a guest" do
      it "can check one guest into multiple rooms" do
        expect(hotel.check_in_guest(name: "Darby",
                                    rooms: [20, 21])).to all(be_a(Dry::Monads::Result::Success))

        expect(hotel.room_available?(20)).to be(false)
        expect(hotel.room_available?(21)).to be(false)
      end

      context "when the room is free" do
        it "returns Success" do
          expect(hotel.check_in_guest(name: "Darby",
                                      rooms: 20)).to all(be_a(Dry::Monads::Result::Success))
        end
      end

      context "when the room is taken" do
        it "returns Failure" do
          hotel.check_in_guest(name: "Darby",
                               rooms: 20)
          expect(hotel.check_in_guest(name: "Paulie",
                                      rooms: 20)).to all(be_a(Dry::Monads::Result::Failure))
        end
      end
    end

    describe "checking out a guest" do
      it "can check out a guest" do
        hotel.check_in_guest(name: "Darby",
                             rooms: 20)
        hotel.check_out_guest(name: "Darby")
        expect(hotel.room_available?(20)).to be(true)
      end

      it "fails to check out a guest if they aren't checked in" do
        expect(hotel.check_out_guest(name: "Darby")).to be_a(Dry::Monads::Result::Failure)
      end
    end

    describe "#room_available?" do
      it "returns false if room is taken" do
        hotel.check_in_guest(name: "Name",
                             rooms: 405)
        expect(hotel.room_available?(405)).to be(false)
      end

      it "returns true if room is available" do
        expect(hotel.room_available?(405)).to be(true)
      end
    end
  end
end
