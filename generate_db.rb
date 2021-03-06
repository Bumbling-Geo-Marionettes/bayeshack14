require 'sqlite3'
require 'csv'

CALLS="./test_calls.csv"
INCIDENTS="./test_incidents.csv"
DATABASE="./test_police_data.db"

begin
    # Create database
    puts "Creating database \"#{DATABASE}\"..."
    puts "WARNING: This will delete the existing database if it exists!"
    File.delete DATABASE if File.exist? DATABASE

    db = SQLite3::Database.open DATABASE

    # Create calls table
    puts "Creating table Calls..."
    db.execute "CREATE TABLE IF NOT EXISTS Calls(id INTEGER PRIMARY KEY, crime_id INTEGER, " +
        "crime_type TEXT, disposition TEXT, full_address TEXT, datetime " +
        "TEXT)"

    # Read calls.csv
    puts "Populating Calls..."
    id = 0
    CSV.foreach(CALLS, {:headers => :first_row}) do |row|
        row.each {|v| v[1].gsub!("'", "''") if not v[1].nil?}
        query = "INSERT INTO Calls VALUES(#{id}, #{row["CRIME_ID"]}," +
            "'#{row["CRIMETYPE"]}','#{row["DISPOSITION"]}'," +
            "'#{row["FULL_ADDRESS"]}','#{row["DATETIME"]}')"
        #puts query
        db.execute query
        id += 1
    end

    # Create incidents table
    puts "Creating table Incidents..."
    db.execute "CREATE TABLE IF NOT EXISTS Incidents(id INTEGER PRIMARY KEY, incident_id INTEGER, 
        category TEXT, description TEXT, district TEXT, resolution TEXT,
        location TEXT, coordinates TEXT, datetime TEXT)"

    # Read incidents.csv
    puts "Populating Incidents..."
    id = 0
    CSV.foreach(INCIDENTS, {:headers => :first_row}) do |row|
        row.each {|v| v[1].gsub!("'", "''") if not v[1].nil?}
        query = "INSERT INTO Incidents VALUES(#{id}, #{row["INCIDENT_ID"]}," +
            "'#{row["CATEGORY"]}','#{row["DESCRIPTION"]}'," +
            "'#{row["DISTRICT"]}','#{row["RESOLUTION"]}'," +
            "'#{row["LOCATION"]}','#{row["COORDINATES"]}','#{row["DATETIME"]}')"
        #puts query
        db.execute query
        id += 1
    end

rescue SQLite3::Exception => e 
    puts "Exception occurred"
    puts e
    
ensure
    db.close if db

end
