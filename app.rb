#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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
		@info = "Success! <b><i>#{@username}.</b></i> We've got your Phone: <b><i>#{@user_phone}.</b></i> <b><i>#{@prefered_barber}</b></i> waiting for you at: <b><i>#{@user_date}.</b></i> <b><i>#{@color}</b></i> paint is available."
		return erb :visit
		
		users_log = File.open './public/users.txt', 'a'
		users_log.write "User: #{@username} Phone: #{@user_phone} Date: #{@user_date} Barber: #{@prefered_barber} Paint: #{@color}\n"
		users_log.close
	end
end

