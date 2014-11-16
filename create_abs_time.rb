require 'sqlite3'

DATABASE="test_police_data.db"

begin
    # Open db
    db = SQLite3::Database.open DATABASE
    query = nil

    # Get time values from Calls
    puts "Creating and populating new column abs_time to Calls..."
    db.transaction
    rs = db.execute "SELECT datetime FROM Calls"
    db.execute "ALTER TABLE Calls ADD abs_time INTEGER"
    rs.each do |row|
        row = row[0].to_s
        secs = DateTime.parse(row).to_time.to_i
        puts "abs_time #{secs.to_s} datetime #{row}"
        db.execute "UPDATE Calls SET abs_time = #{secs.to_s} WHERE datetime = '#{row}'"
    end
    db.commit

    # Get time values from Incidents
    puts "Creating and populating new column abs_time to Incidents..."
    db.transaction
    rs = db.execute "SELECT datetime FROM Incidents"
    db.execute "ALTER TABLE Incidents ADD abs_time INTEGER"
    rs.each do |row|
        row = row[0].to_s
        secs = DateTime.parse(row).to_time.to_i
        db.execute "UPDATE Incidents SET abs_time = #{secs.to_s} WHERE datetime = '#{row}'"
    end
    db.commit

rescue SQLite3::Exception => e 
    puts "Exception occurred"
    puts e
    db.rollback

ensure
    query.close if query
end
