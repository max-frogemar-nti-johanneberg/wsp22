require_relative './model/model.rb'
require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

include Model

# Display Landing Page
#
get('/') do 
    session[:timer] = Time.now
    for_title_homepage = select_all_from_beatmap()
    slim(:"index",locals:{homepage_title_song:for_title_homepage})
end

# Displays an input for new users
# 
get('/users/new') do
    slim(:"/users/new")
end

# Checks whether you have already registered and denies access if so
#
# @params [Hash] params form data
# @option params[Integer] checks if you have session timer, if not continues
before ('/users') do 
    if session[:timer] != nil
        return "Du har redan regristrerat eller loggat in! Logga in Istället!
        <a href='/users/new'> Gå tillbaka </a>"
    end
end

# creates a new user and updates session
#
# @param [String] username, username for the user
# @param [String] password, password for the user
# @param [String] password_confirm, password_confirm for confirmation/same password
#
#   * :message [String] if wrong inputs then an error message with a link back to the users/new
# @see Model#insert_into_user
post('/users') do
    session[:timer] = Time.now
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]
  
    if username.empty? || password.empty? || password_confirm.empty?
        "<h2>All data var inte i fylld!</h2>
        <a href='/users/new'> Gå tillbaka </a>"
    else
        if (password == password_confirm)
            password_digest = BCrypt::Password.create(password)
            insert_into_user(["username","password"], [username, password_digest])
            
            redirect('/')
        else
            "<h2>Lösenord matchade inte!</h2>
            <a href='/users/new'> Gå tillbaka </a>"
        end
    end
end

# Displays login page for new user
#
get('/users/login') do
    slim(:'/users/login')
end

# Checks whether user login to quickly
#
before ('/users/login') do
    if Time.now - session[:timer] < 5
        return "Du loggar in för snabbt! Kolla dina uppgifter noggagrant innan du submitar!
        <a href='/users/new'> Gå tillbaka </a>" 
    end
end

# Attemps login and give user session id, session role and updates session timer. Redirect to '/'
#
# @param [String] username, usernam from the user table to check if exists
# @param [String] password, password from the user table to check if they match
#
# @see Model#all_from_user_where_blank_first
post('/users/login') do
    username = params[:username]
    password = params[:password]
    result = all_from_user_where_blank_first("username", username)
    
    if result != nil
        pwdigest = result["password"]
        id = result["id"]
        role = result["role"]
        if BCrypt::Password.new(pwdigest) == password
        session[:id] = id
        session[:role] = role
        session[:timer] = Time.now
        redirect('/')
        else
            session[:timer] = Time.now
            "<h2>Ditt namn eller lösenord matchade inte!</h2>
            <a href='/users/login'> Gå tillbaka </a>"
        end
    else
        session[:timer] = Time.now
        "<h2>Ditt namn eller lösenord matchade inte!</h2>
        <a href='/users/login'> Gå tillbaka </a>"
    end
end

# Displays an input for new mappers
#
get('/mappers/new') do
    slim(:"/mappers/new")
end

# Attempts to insert a new row in the mapper table. Updates the session 
#
# @param [String] mapper name, used to insert into table 'mapper' column 'name'
#
# @see Model#insert_into_mapper
post('/mappers') do
    if session[:timer] != nil && Time.now - session[:timer] < 5
        return "Lägg inte till mappers så snabbt >:|
        <a href='/users/new'> Gå tillbaka </a>"
    end

    mapper_name = params[:mapper_name]
    session[:timer] = Time.now
    insert_into_mapper("name", mapper_name)
    redirect('/mappers/new')
end

# Uses session information to confirm access to mappers/edit
#
# param[String] role, checks whether user has correct role
before ("/mappers/edit") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays an input and an option for changes in mappers
#
get('/mappers/edit') do
    @mappers = select_all_from_mapper()

    slim(:"/mappers/edit")
end

# Updates an existing 'name' in a row in 'mapper' table
#
# @param[String] mapper_edit_name_input, uses users input to change mapper name
# @param[String] mapper_edit_name_select, users select of which mapper name to change from
#
# @see Model#edit_name_of_mapper
post('/mappers/update') do
    mapper_edit_name_input = params[:mapper_edit_name_input]
    mapper_edit_name_select = params[:mapper_edit_name_select]

    edit_name_of_mapper(mapper_edit_name_input, mapper_edit_name_select)

    redirect('/mappers/edit')
end

# Uses session information to confirm access to mappers/delete
#
# param[String] role, checks whether user has correct role
before ("/mappers/delete") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays a select option to delete row in mapper table
#
# @see Model#select_all_from_mapper
get('/mappers/delete') do 
    @mappers = select_all_from_mapper()
    slim(:"/mappers/delete")
end

# deletes an existing row in 'mapper' table and redirect to '/mappers/delete'
#
# @param[Integer] mapper_id, saves mapper id
#
# @see Model#delete_fom_beatmap_mapper_id
# @see Model#delete_mapper
post('/mappers/delete') do
    mapper_id = params[:mapper_id]

    delete_fom_beatmap_mapper_id(mapper_id)
    delete_mapper(mapper_id)
    redirect('/mappers/delete')
end

# Displays an input for new mappers
#
get('/genres/new') do
    slim(:"/genres/new")
end 

# Creates new genre, updates the session and redirects to '/genres/new'
#
# @param [String] genre_name, genre name used to put in column 'name' in table 'genre'
#
# @see Model#insert_into_genre
post('/genres') do
    if session[:timer] != nil && Time.now - session[:timer] < 5
        return "Lägg inte till genres så snabbt >:|
        <a href='/users/new'> Gå tillbaka </a>"
    end
    session[:timer] = Time.now
    genre_name = params[:genre_name]
    insert_into_genre("name", genre_name)
    redirect('/genres/new')    
end

# Uses session information to confirm access to genres/edit
#
# @param[String] role, checks whether user has correct role
before ("/genres/edit") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays an input and an option for changes in genres
#
# @see Model#select_all_from_genre
get('/genres/edit') do
    @genres = select_all_from_genre()
    slim(:"/genres/edit")
end

# Updates existing 'name' in a row in 'genre' table and redirect to '/genres/edit'
#
# @param[String] user input to change genre name into
# @param[String] users select of which genre name to change from
#
# @see Model#edit_name_of_genre
post('/genres/update') do
    genre_edit_name_input = params[:genre_edit_name_input]
    genre_edit_name_select = params[:genre_edit_name_select]

    edit_name_of_genre(genre_edit_name_input, genre_edit_name_select)
    redirect('/genres/edit')
end

# Uses session information to confirm access to genres/delete
#
# @param[String] role, checks whether user has correct role
before ("/genres/delete") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays a select option to delete row in genre table
#
# @ see Model#select_all_from_genre
get('/genres/delete') do 
    @genres = select_all_from_genre()
    slim(:"/genres/delete")
end

# deletes an existing row in 'genre' table and redirect to '/genres/delete'
#
# @param[Integer] genre_id, saves genre id
#
# @see Model#delete_fom_beatmap_mapper_id
# @see Model#delete_mapper
post('/genres/delete') do
    genre_id = params[:genre_id]

    delete_fom_beatmap_genre_id(genre_id)
    delete_genre(genre_id)
    redirect('/genres/delete')
end

# Uses session information to confirm access to beatmaps/new
#
# @param[String] role, checks whether user has correct role
before ("/beatmaps/new") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays multible input options for beatmap
#
# @see Model#select_all_from_genre
# @see Model#select_all_from_mapper
get('/beatmaps/new') do 
    @genres = select_all_from_genre()
    @mappers = select_all_from_mapper()
    slim(:"/beatmaps/new")
end

# Creates a new row in the beatmap table
#
# @param [String] title_name, title name for the title
# @param [String] description_beatmap, description for the description
# @param [Integer] genre_for_beatmap, genre id for the genre_id
# @param [Integer] mapper_for_beatmap, mapper id for the mapper_id
# @param [String] link_to_beatmap, link for the link
#
# @see Model#insert_into_beatmap
post('/beatmaps') do
    title_name = params[:title_name]
    description_beatmap = params[:description_beatmap]
    genre_for_beatmap = params[:genre_for_beatmap]
    mapper_for_beatmap = params[:mapper_for_beatmap]
    link_to_beatmap = params[:link_to_beatmap]

    insert_into_beatmap(["genre_id", "mapper_id", "title", "description", "link"], [genre_for_beatmap, mapper_for_beatmap, title_name, description_beatmap, link_to_beatmap])
    redirect('/beatmaps/new') 
end

# Uses session information to confirm access to beatmaps/delete
#
# @param[String] role, checks whether user has correct role
before ("/beatmaps/delete") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays a select option to delete row in beatmap table
#
# @see Model#select_all_from_beatmap
get('/beatmaps/delete') do
    @beatmaps = select_all_from_beatmap()
    slim(:"/beatmaps/delete")
end

# Deletes an existing row in beatmap table
#
# @param[String] users select name of which row to delete from beatmap
#
# @see Model#delete_beatmap
post('/beatmaps/delete') do
    beatmap_del_name = params[:beatmap_del_name]
    
    delete_beatmap(beatmap_del_name)
    redirect('/beatmaps/delete')
end

# Displays a single beatmap
#
# @param [Integer] id, picks up beatmap from id
#
# @see Model#select_title_from_beatmap_where_id
# @see Model#select_genreid_from_beatmap_where_id
# @see Model#innerjoin_genrename_with_beatmap_genre_id
# @see Model#select_mapperid_from_beatmap_where_id
# @see Model#select_name_from_mapper_innerjoin_on_mapperid_where_mapperidfrombeatmap
# @see Model#select_description_from_beatmap_where_id
# @see Model#select_link_from_beatmap_where_id
# @see Model#select_username_and_commenttext_from_comment_inner_join_on_userid_where_beatmapid
get('/beatmaps/:id') do 
    id = params[:id]
    title = select_title_from_beatmap_where_id(id).first["title"]
    genre_id_from_beatmap = select_genreid_from_beatmap_where_id(id).first["genre_id"]
    genre = innerjoin_genrename_with_beatmap_genre_id(genre_id_from_beatmap).first["name"]
    mapper_id_from_beatmap = select_mapperid_from_beatmap_where_id(id).first["mapper_id"]
    mapper = select_name_from_mapper_innerjoin_on_mapperid_where_mapperidfrombeatmap(mapper_id_from_beatmap).first["name"]
    description = select_description_from_beatmap_where_id(id).first["description"]
    link_for_beatmap = select_link_from_beatmap_where_id(id).first["link"]
    comment_on_beatmap = select_username_and_commenttext_from_comment_inner_join_on_userid_where_beatmapid(id)

    slim(:"beatmaps/show", locals:{title:title, genre:genre, mapper:mapper, description:description, id:id, comment_on_beatmap:comment_on_beatmap, link_for_beatmap:link_for_beatmap})
end

# Creates a new row in the "comment" table
#
# @param [String] input_description, input from user for column 'comment_text' in 'comment' table
# @param [Integer] id, user id for column 'user_id' in table 'comment'
# @param [String] id, beatmap id for column 'beatmap_id' in table 'comment'
#
# @see Model#insert_into_comment
post('/beatmaps/:id') do
    input_description = params[:input_description]
    user_id = session[:id]
    beatmap_id = params[:id]
    
    insert_into_comment(["comment_text", "user_id", "beatmap_id"], [input_description, user_id, beatmap_id])
    redirect("/beatmaps/#{beatmap_id}")
end

# Checks whether user made the comment for deletion
#
# @param [Integer] id, user id from table 'comment'
#
# @see Model#select_userid_from_comment
before ('/beatmaps/:beatmap_id/delete_comment/:id') do
    comment_id = params[:id].to_i
    owner_id = select_userid_from_comment(comment_id).first["user_id"]
    if session[:id] != owner_id
        redirect('/error')
    end
end

# Deletes an existing row in the "comment" table and redirects to '/beatmaps/#{beatmap_id}'
#
# @param [Integer] beatmap_id, picks up beatmap id to later reirect back
# @param [Integer] id, comment id for deletion
#
# @see Model#delete_comment
post('/beatmaps/?:beatmap_id?/delete_comment/:id') do
    beatmap_id = params[:beatmap_id]
    comment_id = params[:id]
    delete_comment(comment_id)
    redirect("/beatmaps/#{beatmap_id}")
end

# Displays an error page containing message and link back
#
get('/error') do
    slim(:"/error")
end