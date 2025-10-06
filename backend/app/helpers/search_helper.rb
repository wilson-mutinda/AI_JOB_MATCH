module SearchHelper
  # email_search
  def email_search(users, target_email)
    first_index = 0
    last_index = users.length - 1
    target_email = target_email.downcase.strip

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2
      mid_user = users[mid_index]
      mid_user_email = mid_user.email.downcase.strip

      if mid_user_email == target_email
        return { errors: { email: "Email Already Exists!"}}
      elsif mid_user_email < target_email
        first_index = mid_index + 1
      else
        last_index = mid_index - 1
      end
    end
    { errors: { email: '' }}
  end

  # phone_search
  def phone_search(users, target_phone)
    first_index = 0;
    last_index = users.length - 1;
    target_phone = target_phone.to_s.gsub(/\s+/, '')

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_user = users[mid_index]
      mid_user_phone = mid_user.phone

      if mid_user_phone == target_phone
        return { errors: { phone: "Phone Already Exists!"}}
      elsif mid_user_phone < target_phone
        first_index = mid_index + 1
      else
        last_index = mid_index - 1;
      end
      
    end
  end

end
