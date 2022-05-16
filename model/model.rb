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

    def select_all_from_genre()
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM genre")
        return resulat
    end

    def edit_name_of_mapper(mapper_edit_name_input, mapper_edit_name_select)
        db = open_data_base_with_hash()
        db.execute('UPDATE mapper SET name=? WHERE id = ?', mapper_edit_name_input, mapper_edit_name_select)
        return db
    end

    def select_all_from_mapper()
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM mapper")
        return result
    end

    def delete_mapper(name_of_mapper)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM mapper WHERE id = ?",name_of_mapper)
        return db
    end

    def insert_into_genre(kolumns, values)
        db = open_data_base()
        data = db.execute("INSERT INTO genre (#{kolumns}) VALUES (?)",values)
        return data
    end

    def edit_name_of_mapper(genre_edit_name_input, genre_edit_name_select)
        db = open_data_base_with_hash()
        db.execute('UPDATE genre SET name=? WHERE id = ?', genre_edit_name_input, genre_edit_name_select)
        return db
    end

    def delete_genre(name_of_genre)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM genre WHERE id = ?",name_of_genre)
        return db
    end  

    def select_blank_from_user_where_id(name, id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT #{name} FROM user WHERE id = ?",id)
        return result
    end

    def insert_into_beatmap(kolumns, values)
        db = open_data_base()
        db.execute("INSERT INTO beatmap (#{kolumns.join(', ')}) VALUES (?, ?, ?, ?, ?)", values.join(', '))
        return db
    end

    def select_all_from_beatmap()
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM beatmap")
        return result       
    end

    def delete_beatmap(name_of_beatmap)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM beatmap WHERE id = ?",name_of_beatmap)
        return db
    end  

    def insert_into_comment(kolumns, values)
        db = open_data_base_with_hash()
        db.execute("INSERT INTO comment (#{kolumns.join(', ')}) VALUES (?, ?, ?)", values.join(', '))
        return db
    end

    def select_title_from_beatmap_where_id(id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT title FROM beatmap WHERE id = ?", id)
        return result
    end

    def select_genreid_from_beatmap_where_id(id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT genre_id FROM beatmap WHERE id = ?", id)
        return result
    end 

    def innerjoin_genrename_with_beatmap_genre_id(genre_id_from_beatmap)
        db = open_data_base_with_hash()
        result = db.execute("SELECT name FROM genre INNER JOIN beatmap ON genre.id = beatmap.genre_id WHERE genre.id = ?", genre_id_from_beatmap)
        return result
    end
end
    