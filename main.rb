require 'sinatra'
require 'data_mapper'
require 'json'

DATABASE="test_police_data.db"

## Models
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/#{DATABASE}")
class Incident
    include DataMapper::Resource
    property :id, Serial
    property :incident_id, Integer
    property :category, String
    property :description, String
    property :district, String
    property :resolution, String
    property :location, String
    property :coordinates, String
    property :datetime, DateTime
    property :abs_time, Integer
end

class Calls
    include DataMapper::Resource
    property :id, Serial
    property :crime_id, Integer
    property :disposition, String
    property :full_address, String
    property :datetime, DateTime
    property :abs_time, Integer
end
DataMapper.finalize

## Routes
get '/' do
    File.read('public/index.html')
end

get '/calls' do
    content_type :json
    Calls.all.to_json
end

get '/incidents' do
    content_type :json
    Incidents.all.to_json
end
