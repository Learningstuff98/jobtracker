class User < ApplicationRecord
  has_many :applications, dependent: :destroy
  has_many :tasks, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def search(keyword)
    if keyword.present?
      applications.where("company_name ILIKE ?", "%#{keyword}%")
    else
      applications.order("created_at DESC")
    end
  end
end
