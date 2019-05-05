# frozen_string_literal: true

module HotelManagement
  RSpec.describe Hotel do
    subject(:hotel) { described_class.new }

    describe "checking in a guest" do
      context "when the room is free" do
        it "returns Success" do
          expect(hotel.check_in_guest(name: "Darby",
                                      room: 20)).to be_a(Dry::Monads::Result::Success)
        end
      end

      context "when the room is taken" do
        it "returns Failure" do
          hotel.check_in_guest(name: "Darby",
                               room: 20)
          expect(hotel.check_in_guest(name: "Paulie",
                                      room: 20)).to be_a(Dry::Monads::Result::Failure)
        end
      end
    end

    describe "checking out a guest" do
      it "can check out a guest" do
        hotel.check_in_guest(name: "Darby",
                             room: 20)
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
                             room: 405)
        expect(hotel.room_available?(405)).to be(false)
      end

      it "returns true if room is available" do
        expect(hotel.room_available?(405)).to be(true)
      end
    end
  end
end
