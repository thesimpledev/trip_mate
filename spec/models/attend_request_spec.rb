# == Schema Information
#
# Table name: attend_requests
#
#  id         :bigint           not null, primary key
#  trip_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AttendRequest, type: :model do
  describe "validations" do
    it "has a user" do
      user = build(:user)
      attend_request = AttendRequest.new(user: user, trip: create(:trip))
      expect(attend_request.user).to eq(user)
    end

    it "has a trip" do
      trip = build(:trip)
      attend_request = AttendRequest.new(user: build(:user), trip: trip)
      expect(attend_request.trip).to eq(trip)
    end

    it "doesn't allow duplicate records" do
      leader = create(:user)
      user = create(:user)
      FriendRequest.create(requester: leader, requestee: user)
      Friend.create(friend_one_id: leader.id, friend_two_id: user.id)
      trip = create(:trip, creator: leader)
      AttendRequest.create(trip: trip, user: user)

      request = nil
      expect {
        request = AttendRequest.create(trip: trip, user: user)
      }.to_not change(AttendRequest, :count)

      expect(request.errors.full_messages).to eq([
        'Trip already has attend request pending'
      ])
    end

    context "when user is friends with leader" do
      it "is valid" do
        leader = create(:user)
        user = create(:user)
        FriendRequest.create(requester: leader, requestee: user)
        Friend.create(friend_one_id: leader.id, friend_two_id: user.id)
        trip = create(:trip, creator: leader)

        attend_request = AttendRequest.create(trip: trip, user: user)

        expect(attend_request).to be_valid
      end
    end

    context "when user is not friends of leader" do
      it "is invalid" do
        non_friend_leader = create(:user)
        user = create(:user)
        trip = create(:trip, creator: non_friend_leader)

        attend_request = AttendRequest.create(trip: trip, user: user)

        expect(attend_request).to be_invalid
      end

      it "is invalid" do
        non_friend_leader = create(:user)
        user = create(:user)
        trip = create(:trip, creator: non_friend_leader)

        attend_request = AttendRequest.create(trip: trip, user: user)

        expect(attend_request).to be_invalid
      end

      it "has errors" do
        non_friend_leader = create(:user)
        user = create(:user)
        trip = create(:trip, creator: non_friend_leader)

        attend_request = AttendRequest.create(trip: trip, user: user)

        expect(attend_request.errors.full_messages).to eq(
          ["Leader must be your friend"]
        )
      end
    end
  end
end