module RegexHelper
  # email_regex
  def email_format(email)
    email = email.to_s.gsub(/\s+/, '').downcase
    unless email.match?(/\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/i)
      raise 'Invalid Email Format!'
    end
    email
  end

  # phone_regex
  def phone_format(phone)
    phone = phone.to_s.gsub(/\s+/, '')
    if phone.match?(/\A01\d{8}\z/)
      phone = phone.sub(/\A01/, '2541')
    elsif phone.match?(/\A07\d{8}\z/)
      phone = phone.sub(/\A07/, '2547')
    elsif phone.match?(/\A(2541|2547)\d{8}\z/)
      phone = phone
    else
      raise 'Invalid Phone Format!'
    end
    phone
  end

end