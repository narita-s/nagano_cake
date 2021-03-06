class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  def full_name
   last_name.to_s + " " + first_name.to_s
  end

  def full_name_kana
    last_name_kana.to_s + " " + first_name_kana.to_s
  end

end
