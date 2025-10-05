module SearchHelper
  def email_search(users, target_email)
    first_index = 0
    last_index = users.length - 1
    target_email = target_email.downcase.strip

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2
      mid_user = users[mid_index]
      mid_user_email = mid_user.email.downcase.strip

      if mid_user_email == target_email
        raise 'Email Already Exists!'
      elsif mid_user_email < target_email
        first_index = mid_index + 1
      else
        last_index = mid_index - 1
      end
    end
  end
end
