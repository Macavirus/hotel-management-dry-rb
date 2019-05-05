
module HotelManagement
  RSpec.describe Hotel do
    describe "checking in a guest" do
      context "the room is free" do
        it "returns Success" do
          expect(subject.check_in_guest(name: "Darby",
                                        room: 20)).to be_a(Dry::Monads::Result::Success)
        end
      end

      context "the room is taken" do
        it "returns Failure" do
          subject.check_in_guest(name: "Darby",
                                 room: 20)
          expect(subject.check_in_guest(name: "Paulie",
                                        room: 20)).to be_a(Dry::Monads::Result::Failure)
        end
      end
    end

    describe "#room_available?" do
      it "returns false if room is taken" do
        subject.check_in_guest(name: "Name",
                               room: 405)
        expect(subject.room_available?(405)).to be(false)
      end

      it "returns true if room is available" do
        expect(subject.room_available?(405)).to be(true)
      end
    end
  end
end
