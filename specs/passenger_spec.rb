require_relative 'spec_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334"})
    end

    it "is an instance of Passenger" do
      @passenger.must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Passenger.new(id: 0, name: "Smithy")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @passenger.trips.must_be_kind_of Array
      @passenger.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        @passenger.must_respond_to prop
      end

      @passenger.id.must_be_kind_of Integer
      @passenger.name.must_be_kind_of String
      @passenger.phone_number.must_be_kind_of String
      @passenger.trips.must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])

      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        trip.must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same Passenger id" do
      @passenger.trips.each do |trip|
        trip.passenger.id.must_equal 9
      end
    end
  end

  describe "get_drivers method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})

      @passenger.add_trip(trip)
    end

    it "returns an array" do
      drivers = @passenger.get_drivers
      drivers.must_be_kind_of Array
      drivers.length.must_equal 1
    end

    it "all items in array are Driver instances" do
      @passenger.get_drivers.each do |driver|
        driver.must_be_kind_of RideShare::Driver
      end
    end
  end

  describe "total spent method" do
    # Arrange----------------
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})

      @passenger.add_trip(trip)
    end

    it "returns the total amount of money spent on rides" do
      # Act ---------------Assert
      @passenger.total_spent.must_equal 23.10
    end

    it "correctly sums more then one trip" do
      # Arrange ---------
      trip_1 = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})
      @passenger.add_trip(trip_1)

      trip_2 = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})

      @passenger.add_trip(trip_2)

      trip_3 = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})

      @passenger.add_trip(trip_3)

      # Act --------Assert
      @passenger.total_spent.must_equal 92.4
    end
  end

  describe "total time spent method" do
    # Arrange---------------------------
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})

      @passenger.add_trip(trip)
    end

    it "can total up the time spent on a single trip" do
      @passenger.total_time.must_equal (8 * 60) #8 mins in seconds
    end

    it "can total up the time spent for multiple trips" do
      # Arrange -----------
      trip_1 = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})
      @passenger.add_trip(trip_1)

      trip_2 = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})
      @passenger.add_trip(trip_2)

      trip_3 = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})
      @passenger.add_trip(trip_3)

      # Act------------Assessment
      @passenger.total_time.must_equal (32 * 60)
    end
  end
end
