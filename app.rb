#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
  	db.results_as_hash = true	
  	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username = params[:username].capitalize
	@user_phone = params[:user_phone]
	@user_date = params[:user_date]
	@prefered_barber = params[:prefered_barber]
	@color = params[:color]

	# hash
	hh = {:username => 'Enter name',
			:user_phone => 'Enter phone',
			:user_date => 'Enter date'
		}
	
	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ""
		return erb :visit
	else
		db = get_db		
		db.execute 'insert into
			Users
			(
				username,
				phone,
				datestamp,
				barber,
				color
			)
			values
			( ?, ?, ?, ?, ?)', [@username, @user_phone, @user_date, @prefered_barber, @color] 

		@info = "Success! <b><i>#{@username}.</b></i> We've got your Phone: <b><i>#{@user_phone}.</b></i> <b><i>#{@prefered_barber}</b></i> waiting for you at: <b><i>#{@user_date}.</b></i> <b><i>#{@color}</b></i> paint is available."
		return erb :visit
	end
end

get '/showusers' do
	@show_loosers = get_db.execute 'select * from Users'
	erb :showusers
end

