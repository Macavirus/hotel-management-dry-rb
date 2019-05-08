# frozen_string_literal: true

module HotelManagement
  RSpec.describe CheckOutGuest do
    subject(:check_out_guest) { described_class.new(room_manager: RoomManager.new) }

    before do
      @room_manager = RoomManager.new
    end

    context "when the guest doesn't exist" do
      it "fails" do
        expect(check_out_guest.call(name: "Darby").failure?).to be(true)
      end
    end

    context "when the guest is in 1 room" do
      it "can check out a guest" do
        CheckInGuest.new(room_manager: @room_manager).call(name: "Darby",
                                                           rooms: 20)

        expect(described_class.new(room_manager: @room_manager).call(name: "Darby").success?).to be true
      end
    end

    context "when the guest is in many rooms" do
      it "can check out of many rooms" do
        CheckInGuest.new(room_manager: @room_manager).call(name: "Darby",
                                                           rooms: [20, 21])

        expect(described_class.new(room_manager: @room_manager).call(name: "Darby").success?).to be true
      end
    end
  end
end
