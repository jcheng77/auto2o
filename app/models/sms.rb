class Sms

  def self.password(phone, password, type=nil)
    company = "拍立行"
    template = 513
    template = 1081 if type
    template_value = CGI::escape "#code#=#{password}&#company#=#{company}"
    url = "http://v.juhe.cn"              <<
          "/sms/send?"                    <<
          "mobile=#{phone}"               <<
          "&tpl_id=#{template}"           <<
          "&tpl_value=#{template_value}"  <<
          "&key=b837cf1fbc2809288678f954c679495b"
    Typhoeus.post(url, body: {})
  end

  def self.noty_new_tender(phone, tender)
    content = tender.model.truncate(50)
    template_value = CGI::escape "#content#=#{content}"
    url = "http://v.juhe.cn"              <<
          "/sms/send?"                    <<
          "mobile=#{phone}"               <<
          "&tpl_id=859"                   <<
          "&tpl_value=#{template_value}"  <<
          "&key=b837cf1fbc2809288678f954c679495b"
    Typhoeus.post(url, body: {})
  end

end