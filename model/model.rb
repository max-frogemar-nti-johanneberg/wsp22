# handles data and logic
#
module Model

    # opens data base in hash form
    #
    # @return [SQLite3::Database] Containing database
    def open_data_base_with_hash()
        db = SQLite3::Database.new('db/relationship_osu_site.db')
        db.results_as_hash = true
        return db
    end

    # opens data base
    #
    # @return [SQLite3::Database] Containing database 
    def open_data_base()
        db = SQLite3::Database.new('db/relationship_osu_site.db')
        return db
    end

    # Attemps to insert a new row in users
    #
    # @param [Array] params form data
    # @option params [String] kolumn, the kolumn name to insert into
    # @option params [String] values, what to put into kolumns
    def insert_into_user(kolumns, values)
        db = open_data_base()
        data = db.execute("INSERT INTO user (#{kolumns.join(', ')}) VALUES (?,?)",values)
    end

    # Attemps to select all column has a certain value
    #
    # @param [Array] params form data
    # @option params [String] kolumn, kolumn where data is selected
    # @option params [String] values, what row data is selected
    #
    # @return [Hash] data from database
    def all_from_user_where_blank_first(kolumn, values)
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM user WHERE #{kolumn} = ?",values).first
        return result
    end

    # Attemps to insert a new row in mappers
    #
    # @param [Array] params form data
    # @option params [String] kolumn, kolumn where data is inserted into
    # @option params [String] values, what data is inserted into mapper
    def insert_into_mapper(kolumns, values)
        db = open_data_base()
        data = db.execute("INSERT INTO mapper (#{kolumns}) VALUES (?)",values)
    end

    # Attemps to selects all from genre
    #
    # @return [Hash] data from database
    def select_all_from_genre()
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM genre")
        return result
    end

    # Attemps to update a kolumn in a row in mapper
    #
    # @param [Array] params form data
    # @option params [String] mapper_edit_name_input, updated new name
    # @option params [String] mapper_edit_name_select, previous name
    def edit_name_of_mapper(mapper_edit_name_input, mapper_edit_name_select)
        db = open_data_base_with_hash()
        db.execute('UPDATE mapper SET name=? WHERE id = ?', mapper_edit_name_input, mapper_edit_name_select)
    end

    # Attemps to selects all from mapper
    #
    # @return [Hash] data from database
    def select_all_from_mapper()
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM mapper")
        return result
    end

    # Attemps to delete a row in mapper
    #
    # @param [Integer] params form data
    # @option params [String] mapper_id, mapper id to identify row deletion
    def delete_mapper(mapper_id)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM mapper WHERE id = ?",mapper_id)
    end

    # Attemps to insert a new row in genre
    #
    # @param [Array] params form data
    # @option params [String] kolumns, kolumn where data is inserted into
    # @option params [String] values, what data is inserted into genre
    def insert_into_genre(kolumns, values)
        db = open_data_base()
        data = db.execute("INSERT INTO genre (#{kolumns}) VALUES (?)",values)
    end

    # Attemps to update a kolumn in a row in genre
    #
    # @param [Array] params form data
    # @option params [String] genre_edit_name_input, updated new name
    # @option params [String] genre_edit_name_select, previous name
    def edit_name_of_genre(genre_edit_name_input, genre_edit_name_select)
        db = open_data_base_with_hash()
        db.execute('UPDATE genre SET name=? WHERE id = ?', genre_edit_name_input, genre_edit_name_select)
    end

    # Attemps to delete a row in genre
    #
    # @param [Integer] params form data
    # @option params [Integer] genre_id, genre id to identify row deletion
    def delete_genre(genre_id)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM genre WHERE id = ?", genre_id)
    end  

    # Attemps to select a column in a user
    #
    # @param [Array] params form data
    # @param [Integer] params form data
    # @option params [String] name, what kolumn data in collected from
    # @option params [Integer] id, id to identify what row
    #
    # @return [Hash] data from database
    def select_blank_from_user_where_id(name, id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT #{name} FROM user WHERE id = ?",id)
        return result
    end

    # Attemps to insert a new row in beatmap
    #
    # @param [Array] params form data
    # @option params [String] kolumns, kolumn where data is inserted into
    # @option params [String] kolumns, what data is inserted into beatmap
    def insert_into_beatmap(kolumns, values)
        db = open_data_base()
        db.execute("INSERT INTO beatmap (#{kolumns.join(', ')}) VALUES (?, ?, ?, ?, ?)", values)
    end

    # Attemps to select all in beatmap
    #
    # @return [Hash] data from database
    def select_all_from_beatmap()
        db = open_data_base_with_hash()
        result = db.execute("SELECT * FROM beatmap")
        return result       
    end

    # Attemps to delete a row in beatmap
    #
    # @param [Array] params form data
    # @option params [Integer] id_of_beatmap, id of what row to delete
    def delete_beatmap(id_of_beatmap)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM beatmap WHERE id = ?",id_of_beatmap)
    end  

    # Attemps to insert a new row in comment
    #
    # @param [Array] params form data    
    # @option params [Integer] kolumns,  kolumn where data is inserted into
    # @option params [Integer] values, what data is inserted into comment
    def insert_into_comment(kolumns, values)
        db = open_data_base_with_hash()
        db.execute("INSERT INTO comment (#{kolumns.join(', ')}) VALUES (?, ?, ?)", values)
    end

    # Attemps to select a title in beatmap
    #
    # @param [Integer] params form data
    # @option params [Integer] id, id to identify what row to select
    #
    # @return [Hash] data from database
    def select_title_from_beatmap_where_id(id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT title FROM beatmap WHERE id = ?", id)
        return result
    end

    # Attemps to select a genreid in beatmap
    #
    # @param [Integer] params form data
    # @option params [Integer] id, id to identify what row to select
    #
    # @return [Hash] data from database
    def select_genreid_from_beatmap_where_id(id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT genre_id FROM beatmap WHERE id = ?", id)
        return result
    end 

    # Attemps to create a new row with innerjoin where name of genre is given instead of genre_id in beatmap 
    #
    # @param [Integer] params form data
    # @option params [Integer] genre_id_from_beatmap, genre id from beatmap to identify what name from genre to select
    #
    # @return [Hash] data from database
    def innerjoin_genrename_with_beatmap_genre_id(genre_id_from_beatmap)
        db = open_data_base_with_hash()
        result = db.execute("SELECT name FROM genre INNER JOIN beatmap ON genre.id = beatmap.genre_id WHERE genre.id = ?", genre_id_from_beatmap)
        return result
    end

    # Attemps to select a mapperid in beatmap
    #
    # @param [Integer] params form data
    # @option params [Integer] beatmap_id, id to identify what row to select from
    #
    # @return [Hash] data from databas
    def select_mapperid_from_beatmap_where_id(beatmap_id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT mapper_id FROM beatmap WHERE id = ?", beatmap_id)
        return result
    end

    # Attemps to select a description in beatmap
    #
    # @param [Integer] params form data
    # @option params [Integer] beatmap_id, id to identify what row to select from
    #
    # @return [Hash] data from database 
    def select_description_from_beatmap_where_id(beatmap_id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT description FROM beatmap WHERE id = ?", beatmap_id)
        return result
    end

    # Attemps to select a link in beatmap
    #
    # @param [Integer] params form data
    # @option params [Integer] beatmap_id, id to identify what row to select from
    #
    # @return [Hash] data from databas
    def select_link_from_beatmap_where_id(beatmap_id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT link FROM beatmap WHERE id = ?", beatmap_id)
        return result
    end

    # Attemps to build a new row with innerjoin where name of mapper is given instead of mapper_id in beatmap 
    #
    # @param [Integer] params form data
    # @option params [Integer] mapper_id_from_beatmap, mapper id from beatmap to identify what name from mapper to select
    #
    # @return [Hash] data from database
    def select_name_from_mapper_innerjoin_on_mapperid_where_mapperidfrombeatmap(mapper_id_from_beatmap)
        db = open_data_base_with_hash()
        result = db.execute("SELECT name FROM mapper INNER JOIN beatmap ON mapper.id = beatmap.mapper_id WHERE mapper.id = ?", mapper_id_from_beatmap)
        return result
    end

    # Attemps to build a new row with innerjoin where username, cooment_text and user_id of comment is given instead of user_id in beatmap
    #
    # @param [Integer] params form data
    # @option params [Integer] beatmap_id, beatmap id to identify what row to select from comment
    #
    # @return [Hash] data from database
    def select_username_and_commenttext_from_comment_inner_join_on_userid_where_beatmapid(beatmap_id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT username, comment_text, comment.id, user_id FROM comment INNER JOIN  user ON user_id = user.id WHERE beatmap_id = ?", beatmap_id)
        return result
    end

    # Attempts to delete row in comment
    #
    # @param [Integer] params form data
    # @option params [Integer] id, id to identify what row to delete
    def delete_comment(id)
        db = open_data_base_with_hash()
        db.execute("DELETE FROM comment WHERE id = ?",id)
    end

    # Attempts to delete row in beatmap
    #
    # @param [Integer] params form data
    # @option params [Integer] id, id to identify what row to delete
    def delete_fom_beatmap_mapper_id(id) 
        db = open_data_base_with_hash()
        db.execute("DELETE FROM beatmap WHERE mapper_id = ?", id)
    end

    # Attempts to delete row in beatmap
    #
    # @param [Integer] params form data
    # @option params [Integer] id, id to identify what row to delete
    def delete_fom_beatmap_genre_id(id) 
        db = open_data_base_with_hash()
        db.execute("DELETE FROM beatmap WHERE genre_id = ?", id)
    end

    # Attemps to a select user_id in comment
    #
    # @param [Integer] params form data
    # @option params [Integer] comment_id, id to identify what row to select user_id from
    #
    # @return [?] ??? 
    def select_userid_from_comment(comment_id)
        db = open_data_base_with_hash()
        result = db.execute("SELECT user_id FROM comment WHERE id = ?", comment_id)
        return result
    end
end
    