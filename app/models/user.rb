class User < ApplicationRecord
  has_many :applications
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def search(keyword)
    if keyword.present?
      Application.where("company_name ILIKE ?", "%#{keyword}%") 
    else
      self.applications.order("created_at DESC")
    end
  end

end
