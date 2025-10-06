module SortHelper
  def sort_user_email(users)
    if users.length <= 1
      return users
    end

    random_email = users.delete_at(rand(users.length));

    left, right = users.partition do |user|
      user.email < random_email.email
    end

    sort_user_email(left) + [random_email] + sort_user_email(right)
  end
end