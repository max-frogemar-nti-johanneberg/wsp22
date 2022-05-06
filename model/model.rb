module Model
    def open_data_base_with_hash()
        db = SQLite3::Database.new('db/relationship_osu_site.db')
        db.results_as_hash = true
        return db
    end

    def open_data_base()
        db = SQLite3::Database.new('db/relationship_osu_site.db')
        return db
    end

    def all_from_beatmap()
        db = open_data_base_with_hash()
        all = db.execute("SELECT * FROM beatmap")
        return all
    end

    def insert_into_user(kolumns, values)
        db = open_data_base()
        data = db.execute("INSERT INTO user (#{kolumns.join(', ')}) VALUES (?,?)",values)
        return data
    end

    def all_from_user_where_blank_first(kolumn, values)
        db = open_data_base_with_hash()
        data = db.execute("SELECT * FROM user WHERE #{kolumn} = ?",values).first
        return data
    end

    def insert_into_mapper(kolumns, values)
        db = open_data_base()
        data = db.execute("INSERT INTO mapper (#{kolumns}) VALUES (?)",values)
        return data
    end
end
    