class Device < ActiveRecord::Base


  belongs_to :user
  belongs_to :dealer
  belongs_to :admin_user

end


class IosDevice < Device

end

class AndroidDevice < Device

end

class WindowsPhone < Device

end