class Sms
  
  
  def self.password(phone, password)
    company = "紫薯"
    template_value = CGI::escape "#code#=#{password}&#company#=#{company}"
    url = "http://v.juhe.cn"              <<
          "/sms/send?"                    <<
          "mobile=#{phone}"               <<
          "&tpl_id=513"                   <<
          "&tpl_value=#{template_value}"  <<
          "&key=b837cf1fbc2809288678f954c679495b"
    Typhoeus.post(url, body: {})
  end
  
  
  
  
end