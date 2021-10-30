class PagesController < ApplicationController

  def home
    if current_user
      @applications = current_user.search(params[:keyword])
    end
  end

end
