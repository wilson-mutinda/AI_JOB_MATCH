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

  # binary email_search
  def binary_email_search(users, target_email, current_user_id)
    first_index = 0;
    last_index = users.length - 1;

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_user = users[mid_index]
      mid_user_email = mid_user.email

      if mid_user_email == target_email
        if mid_user.id != current_user_id
          return { errors: { email: "Email already exists!"}}
        else
          return nil
        end
      elsif mid_user_email < target_email
        first_index = mid_index + 1;
      else
        last_index = mid_index - 1;
      end
    end
  end

  # binary phone_search
  def binary_phone_search(users, target_phone, current_user_id)
    first_index = 0;
    last_index = users.length - 1;

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_user = users[mid_index]
      mid_user_phone = mid_user.phone

      if mid_user_phone == target_phone
        if mid_user.id != current_user_id
          return { errors: { phone: "Phone already exists!"}}
        else
          return nil
        end
      elsif mid_user_phone < target_phone
        first_index = mid_index + 1;
      else
        last_index = mid_index - 1;
      end
    end
  end

  # binary_user_search with target_id
  def binary_user_search(users, target_id)
    first_index = 0;
    last_index = users.length - 1;

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_user = users[mid_index]
      mid_user_id = mid_user.id
      
      if mid_user_id == target_id
        return mid_user
      elsif mid_user_id > target_id
        last_index = mid_index - 1
      else
        first_index = mid_index + 1
      end
    end
  end

  # login_email_search
  def login_email_search(users, target_email)
    first_index = 0;
    last_index = users.length - 1;

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_user = users[mid_index]
      mid_user_email = mid_user.email.downcase

      if mid_user_email == target_email
        return mid_user
      elsif mid_user_email > target_email
        last_index = mid_index - 1;
      else
        first_index = mid_index + 1;
      end
    end
  end

end
