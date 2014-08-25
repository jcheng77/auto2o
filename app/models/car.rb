class Car < ActiveRecord::Base

  has_many :tenders, inverse_of: :car


  def find_by_model(model)

  end

end
