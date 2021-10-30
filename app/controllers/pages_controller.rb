class PagesController < ApplicationController

  def home
    if current_user
      @applications = current_user.applications.order("created_at DESC")
    end
  end

end
