module RegexHelper
  # email_regex
  def email_format(email)
    email = email.to_s.gsub(/\s+/, '').downcase
    unless email.match?(/\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/i)
      return { errors: { email: "Invalid Email Format!"}}
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
      return { errors: { phone: "Invalid Phone Format!"}}
    end
    phone
  end

  # password_regex
  def password_regex(password, password_confirmation)
    password = password.to_s
    password_confirmation = password_confirmation.to_s

    if password.blank? || password_confirmation.blank?
      return { errors: { password: "Password is required!", password_confirmation: "Password confirmation is required"}}
    end

    if password.present? && password_confirmation.blank?
      return { errors: { password_confirmation: "password confirmation is required!"} }
    elsif password.blank? && password_confirmation.present?
      return { errors: { password: "Password is required!"} }
    end

    if password != password_confirmation
      return { errors: { password_confirmation: "Password mismatch!"} }
    end

    # password_format
    unless password.match?(/[A-Za-z]/) && password.match?(/\d/)
      return { errors: { password: "Password should have both leters and digits"} }
    end

    # at leat 8 characters
    unless password.length >= 8
      return { errors: { password: "Password should have at least 8 characters!"} }
    end

    # no error
    nil
  end
end