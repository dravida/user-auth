class SessionsController < ApplicationController
  def new
  end

  def create
  		clear_session
	  	user = User.authenticate(params[:email], params[:password])
	  	if user
	  		session[:user_id] = user.id
	  		redirect_to root_url, notice: "Login successful!"
	  	else
	  		flash.now.alert = "Invalid email or password"
	  		render "new"
	  	end
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged Out!"
  end

  def clear_session
  	session[:user_id] = nil if session[:user_id]
  end

end
