module RegexHelper
  def email_format(email)
    email = email.to_s.gsub(/\s+/, '').downcase
    unless email.match?(/\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/i)
      raise 'Invalid Email Format!'
    end
    email
  end
end