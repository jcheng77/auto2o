class Device < ActiveRecord::Base


  belongs_to :user, inverse_of: :devices
  belongs_to :dealer, inverse_of: :devices
  belongs_to :admin_user, inverse_of: :devices

end


class IosDevice < Device

end

class AndroidDevice < Device

end

class WindowsPhone < Device

end