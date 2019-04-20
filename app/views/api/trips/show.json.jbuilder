json.set! "trip" do
  json.set! @trip.id do
    json.extract! @trip, :id, :start_date, :end_date, :image_url, :title, :location, :creator_id, :duration, :days_until
  end
end

json.set! "user" do
  json.set! @trip.creator.id do
    json.extract! @trip.creator, :first_name, :last_name, :email, :id
    json.fullName "#{@trip.creator.first_name} #{@trip.creator.last_name}"
  end
end