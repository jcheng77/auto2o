class Shop < ActiveRecord::Base

  belongs_to :city
  has_and_belongs_to_many :tenders
  has_many :dealers, inverse_of: :shop
  has_many :deals, :through => :dealers
  has_and_belongs_to_many :brands, join_table: "brands_shops", class_name: "Car::Brand"
  has_many :comments, inverse_of: :shop
  has_and_belongs_to_many :models

end
