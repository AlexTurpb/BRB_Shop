#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where barber_name=?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (barber_name) values (?)', [barber]
		end
	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
  	db.results_as_hash = true	
  	return db
end

configure do
	#db = get_db
	begin
	get_db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'
	get_db.execute 'CREATE TABLE IF NOT EXISTS
	  	"Barbers"
	  	(
	  		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
	  		"barber_name" TEXT UNIQUE
	  	)'

	seed_db get_db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Fourth Barber']

	# get_db.execute "insert or ignore into Barbers(barber_name) values( ?)", 'Walter White'
	# get_db.execute "insert or ignore into Barbers(barber_name) values( ?)", 'Jessie Pinkman'
	# get_db.execute "insert or ignore into Barbers(barber_name) values( ?)", 'Gus Fring'
	end
end

before do
	@show_barbers = get_db.execute 'select * from Barbers'
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
	@show_loosers = get_db.execute 'select * from Users order by Id asc';
	erb :showusers
end

