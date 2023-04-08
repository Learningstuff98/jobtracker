class PagesController < ApplicationController
  def home
    @applications = current_user.search(params[:keyword]) if current_user
  end
end
