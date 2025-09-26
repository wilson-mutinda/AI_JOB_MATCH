class UserMailer < ApplicationMailer
  def login_notification(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Login Alert - #{ Rails.application.class.module_parent_name }"
    )
  end
end
