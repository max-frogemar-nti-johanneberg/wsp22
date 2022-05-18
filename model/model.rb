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
    end

    def all_from_user_where_blank_first(kolumn, values)
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM user WHERE #{kolumn} = ?",values).first
        return result
    end

    def insert_into_mapper(kolumns, values)
        db = open_data_base()
        data = db.execute("INSERT INTO mapper (#{kolumns}) VALUES (?)",values)
    end

    def select_all_from_genre()
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM genre")
        return result
    end

    def edit_name_of_mapper(mapper_edit_name_input, mapper_edit_name_select)
        db = open_data_base_with_hash()
        db.execute('UPDATE mapper SET name=? WHERE id = ?', mapper_edit_name_input, mapper_edit_name_select)
    end

    def select_all_from_mapper()
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM mapper")
        return result
    end

    def delete_mapper(mapper_id)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM mapper WHERE id = ?",mapper_id)
    end

    def insert_into_genre(kolumns, values)
        db = open_data_base()
        data = db.execute("INSERT INTO genre (#{kolumns}) VALUES (?)",values)
    end

    def edit_name_of_genre(genre_edit_name_input, genre_edit_name_select)
        db = open_data_base_with_hash()
        db.execute('UPDATE genre SET name=? WHERE id = ?', genre_edit_name_input, genre_edit_name_select)
    end

    def delete_genre(genre_id)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM genre WHERE id = ?", genre_id)
    end  

    def select_blank_from_user_where_id(name, id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT #{name} FROM user WHERE id = ?",id)
        return result
    end

    def insert_into_beatmap(kolumns, values)
        db = open_data_base()
        db.execute("INSERT INTO beatmap (#{kolumns.join(', ')}) VALUES (?, ?, ?, ?, ?)", values)
    end

    def select_all_from_beatmap()
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM beatmap")
        return result       
    end

    def delete_beatmap(name_of_beatmap)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM beatmap WHERE id = ?",name_of_beatmap)
    end  

    def insert_into_comment(kolumns, values)
        db = open_data_base_with_hash()
        db.execute("INSERT INTO comment (#{kolumns.join(', ')}) VALUES (?, ?, ?)", values)
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

    def select_mapperid_from_beatmap_where_id(beatmap_id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT mapper_id FROM beatmap WHERE id = ?", beatmap_id)
        return result
    end

    def select_description_from_beatmap_where_id(beatmap_id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT description FROM beatmap WHERE id = ?", beatmap_id)
        return result
    end

    def select_link_from_beatmap_where_id(beatmap_id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT link FROM beatmap WHERE id = ?", beatmap_id)
        return result
    end

    def select_name_from_mapper_innerjoin_on_mapperid_where_mapperidfrombeatmap(mapper_id_from_beatmap)
        db = open_data_base_with_hash()
        result = db.execute("SELECT name FROM mapper INNER JOIN beatmap ON mapper.id = beatmap.mapper_id WHERE mapper.id = ?", mapper_id_from_beatmap)
        return result
    end

    def select_username_and_commenttext_from_comment_inner_join_on_userid_where_beatmapid(beatmap_id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT username, comment_text, comment.id, user_id FROM comment INNER JOIN  user ON user_id = user.id WHERE beatmap_id = ?", beatmap_id)
        return result
    end

    def delete_comment(id)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM comment WHERE id = ?",id)
    end

    def delete_fom_beatmap_mapper_id(id) 
        db = open_data_base_with_hash()
        db.execute("DELETE FROM beatmap WHERE mapper_id = ?", id)
    end

    def delete_fom_beatmap_genre_id(id) 
        db = open_data_base_with_hash()
        db.execute("DELETE FROM beatmap WHERE genre_id = ?", id)
    end

    def select_userid_from_comment(comment_id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT user_id FROM comment WHERE id = ?", comment_id)
        return result
    end
end
    