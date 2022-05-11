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
    for_title_homepage = all_from_beatmap()
    slim(:"index",locals:{homepage_title_song:for_title_homepage})
end

# Displays an input for new users
# 
get('/users/new') do
    slim(:"/users/new")
end

# Attempts to insert a new row in the user table
#
# @params [Hash] params form data
# @option params [String] username for the table user
# @option params [String] password for the table user
# @option params [String] password_confirm for password confirmation
#
# @return [Hash]
#   * :message[String] the error message with a link back to the users/new
post('/users') do
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
get('/users/login') do
    slim(:'/users/login')
end

# Gives user an session id and session role
#
# @params [Hash] params form data
# @option params [String] username from the user table
# @option params [String] password from the user table
#
# @return [Hash]
#   * :message [String] the error message with a link back to the users/login
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
        redirect('/')
        else
            "<h2>Ditt namn eller lösenord matchade inte!</h2>
            <a href='/users/login'> Gå tillbaka </a>"
        end
    else
        "<h2>Ditt namn eller lösenord matchade inte!</h2>
        <a href='/users/login'> Gå tillbaka </a>"
    end
end

# Displays an input for new mappers
get('/mappers/new') do
    slim(:"/mappers/new")
end

# Attempts to insert a new row in the mapper table
#
# @params [Hash] params form data
# @option params [String] mapper name for the mapper user
post('/mappers') do
    mapper_name = params[:mapper_name]

    insert_into_mapper("name", mapper_name)

    redirect('/mappers/new')
end

# Uses session information to confirm access to mappers/edit
#
# @params [Hash] params form data
# @option params[String] checks whether user has correct role
before ("/mappers/edit") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays an input and an option for changes in mappers
get('/mappers/edit') do
    select_all_from_genre()

    slim(:"/mappers/edit")
end

# Attempts to change existing name in a row in mapper table
#
# @params [Hash] params form data
# @option params[String] user input to change mapper name into
# @option params[String] users select of which mapper name to change from
post('/mappers/update') do
    mapper_edit_name_input = params[:mapper_edit_name_input]
    mapper_edit_name_select = params[:mapper_edit_name_select]

    edit_name_of_genre(mapper_edit_name_input, mapper_edit_name_select)

    redirect('/mappers/edit')
end

# Uses session information to confirm access to mappers/delete
#
# @params [Hash] params form data
# @option params[String] checks whether user has correct role
before ("/mappers/delete") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays a select option to delete row in mapper table
get('/mappers/delete') do 
    select_all_from_mapper()
    slim(:"/mappers/delete")
end

# Attempts to delete an existing row in mapper table
#
# @params [Hash] params form data
# @option params[String] user input to change mapper name into
# @option params[String] users select of name of which row to delete from mapper
post('/mappers/delete') do
    mapper_del_name = params[:mapper_del_name]

    delete_mapper(mapper_del_name)
    redirect('/mappers/delete')
end

# Displays an input for new mappers
get('/genres/new') do
    slim(:"/genres/new")
end 

# Attempts to insert a new row in the genre table
#
# @params [Hash] params form data
# @option params [String] genre name for the genre user
post('/genres') do
    genre_name = params[:genre_name]

    insert_into_genre("name", genre_name)
    redirect('/genres/new')    
end

# Uses session information to confirm access to genres/edit
#
# @params [Hash] params form data
# @option params[String] checks whether user has correct role
before ("/genres/edit") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays an input and an option for changes in genres
get('/genres/edit') do
    select_all_from_genre()
    slim(:"/genres/edit")
end

# Attempts to change existing name in a row in genre table
#
# @params [Hash] params form data
# @option params[String] user input to change genre name into
# @option params[String] users select of which genre name to change from
post('/genres/update') do
    genre_edit_name_input = params[:genre_edit_name_input]
    genre_edit_name_select = params[:genre_edit_name_select]

    edit_name_of_genre(genre_edit_name_input, genre_edit_name_select)
    redirect('/genres/edit')
end

# Uses session information to confirm access to genres/delete
#
# @params [Hash] params form data
# @option params[String] checks whether user has correct role
before ("/genres/delete") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays a select option to delete row in genre table
get('/genres/delete') do 
    select_all_from_genre()
    slim(:"/genres/delete")
end

# Attempts to delete an existing row in genre table
#
# @params [Hash] params form data
# @option params[String] users select name of which row to delete from genre
post('/genres/delete') do
    genre_del_name = params[:genre_del_name]

    delete_genre(genre_del_name)
    redirect('/genres/delete')
end

# Uses session information to confirm access to beatmaps/new
#
# @params [Hash] params form data
# @option params[String] checks whether user has correct role
before ("/beatmaps/new") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays multible input options for beatmap
get('/beatmaps/new') do 
    user_role = select_blank_from_user_where_id("role", session[:id]).first["role"]

    if user_role == "Admin"
        @genres = select_all_from_genre()
        @mappers = select_all_from_mapper()
        slim(:"/beatmaps/new")
    else
        "Du har inte tillgång till denna sidan"
        redirect('/error')
    end
end

# Attempts to insert a new row in the beatmap table
#
# @params [Hash] params form data
# @option params [String] title name for the title
# @option params [String] description for the description
# @option params [Integer] genre id for the genre_id
# @option params [Integer] mapper id for the mapper_id
# @option params [String] link to a the beatmap for the link
post('/beatmaps') do
    title_name = params[:title_name]
    description_beatmap = params[:description_beatmap]
    genre_for_beatmap = params[:genre_for_beatmap]
    mapper_for_beatmap = params[:mapper_for_beatmap]
    link_to_beatmap = params[:link_to_beatmap]

    insert_into_beatmap([genre_id, mapper_id, title, description, link], [genre_for_beatmap, mapper_for_beatmap, title_name, description_beatmap, link_to_beatmap])
    redirect('/beatmaps/new') 
end

# Uses session information to confirm access to beatmaps/delete
#
# @params [Hash] params form data
# @option params[String] checks whether user has correct role
before ("/beatmaps/delete") do
    if session[:role] != "Admin"
        redirect('/error')
    end
end

# Displays a select option to delete row in beatmap table
get('/beatmaps/delete') do
    select_all_from_beatmap()
    slim(:"/beatmaps/delete")
end

# Attempts to delete an existing row in beatmap table
#
# @params [Hash] params form data
# @option params[String] users select name of which row to delete from beatmap
post('/beatmaps/delete') do
    beatmap_del_name = params[:beatmap_del_name]
    
    delete_beatmap(beatmap_del_name)
    redirect('/beatmaps/delete')
end

# Displays an site with information from a certain beatmap
#
# @params [Hash] params form data
# @option params [Integer] pick beatmap from id
#
# @return[String] title from title in beatmap
# @return[String] genre name from genre connected with id from beatmap
# @return[String] mapper name from mapper connected with id from beatmap
# @return[String] description from description in beatmap
# @return[String] link for beatmap from link in beatmap
# @return[String] comment text feom comment
get('/beatmaps/:id') do 
    id = params[:id]
    db = open_data_base_with_hash()
    title = select_title_from_beatmap_where_id(id).first["title"]
    genre_id_from_beatmap = select_genreid_from_beatmap_where_id(id).first["genre_id"]
    genre = innerjoin_genrename_with_beatmap_genre_id(genre_id_from_beatmap).first["name"]
    mapper_id_from_beatmap = db.execute("SELECT mapper_id FROM beatmap WHERE id = ?", id).first["mapper_id"]
    mapper = db.execute("SELECT name FROM mapper INNER JOIN beatmap ON mapper.id = beatmap.mapper_id WHERE mapper.id = ?", mapper_id_from_beatmap).first["name"]
    description = db.execute("SELECT description FROM beatmap WHERE id = ?", id).first["description"]
    link_for_beatmap = db.execute("SELECT link FROM beatmap WHERE id = ?", id).first["link"]
    comment_on_beatmap = db.execute("SELECT username, comment_text FROM comment INNER JOIN  user ON user_id = user.id WHERE beatmap_id = ?", id)

    slim(:"beatmaps/show", locals:{title:title, genre:genre, mapper:mapper, description:description, id:id, comment_on_beatmap:comment_on_beatmap, link_for_beatmap:link_for_beatmap})
end

# Attempts to insert a new row in the comment table
#
# @params [Hash] params form data
# @option params [String] input description for comment text in comment
# @option params [Integer] user id for user_id in comment
# @option params [String] beatmap id for beatmap_id in comment
post('/beatmaps/:id') do
    input_description = params[:input_description]
    user_id = session[:id]
    beatmap_id = params[:id]

    insert_into_comment([comment_text, user_id, beatmap_id], [input_description, user_id, beatmap_id])
    redirect("/beatmaps/#{beatmap_id}")
end

# Displays an error page containing message and link back
get('/error') do
    slim(:"/error")
end

  