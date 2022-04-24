module Model
    def open_data_base()
        db = SQLite3::Database.new('db/relationship_osu_site.db')
        db.results_as_hash = true
        return db
    end
end
    