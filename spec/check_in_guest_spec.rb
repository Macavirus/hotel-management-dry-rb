# frozen_string_literal: true

module HotelManagement
  RSpec.describe CheckInGuest do
    subject(:check_in_guest) { described_class.new(room_manager: RoomManager.new) }

    describe "checking in a guest" do
      context "when the rooms are free" do
        it "can check 1 guest into 1 room" do
          expect(check_in_guest.call(name: "Darby", rooms: 20).success?).to be(true)
        end

        it "can check 1 guest into many rooms" do
          expect(check_in_guest.call(name: "Darby", rooms: [19, 20]).success?).to be(true)
        end

        it "cannot check in if rooms are not unique" do
          expect(check_in_guest.call(name: "Darby", rooms: [19, 19]).success?).to be(false)
        end
      end

      context "when the rooms are full" do
        it "cannot check 1 guest into 1 room" do
          check_in_guest.call(name: "Leuven", rooms: 20)
          expect(check_in_guest.call(name: "Darby", rooms: 20).success?).to be(false)
        end

        it "cannot check 1 guest into many rooms" do
          check_in_guest.call(name: "Leuven", rooms: 20)
          expect(check_in_guest.call(name: "Darby", rooms: [20, 21]).success?).to be(false)
        end
      end
    end
  end
end
