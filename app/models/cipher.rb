class Cipher
  
  def self.gen
    # only:  c d e f h k p x y
    generated_password = SecureRandom.urlsafe_base64(18).downcase.tr!("-_a0ob6gq9i1jlrmnt7uvwz25s348", "").first(4)
    Rails.logger.info("PASSWORD:::::::::::#{generated_password}") if Rails.env.development?
    generated_password
  end
  
end