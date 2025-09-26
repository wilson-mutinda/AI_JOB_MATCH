class UserLogin
  def self.send_login_email(user)
    UserMailer.login_notification(user).deliver_now
  end
end