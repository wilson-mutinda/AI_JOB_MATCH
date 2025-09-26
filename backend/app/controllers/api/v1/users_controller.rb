class Api::V1::UsersController < ApplicationController

  # create_user
  def create_user
    begin
      # user_params
      # email_param
      email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
      if email_param.blank?
        render json: { errors: { email: "Email cannot be empty!"}}, status: :unprocessable_entity
        return
      else
        # email_format
        email_format = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/i
        unless email_param.match(email_format)
          render json: { errors: {email: "Invalid email format!"}}, status: :unprocessable_entity
          return
        else
          # email should not exist
          email  = User.find_by(email: email_param)
          if email
            render json: { errors: { email: "Email Already exists!"}}, status: :unprocessable_entity
            return
          else
            email_param = email_param.to_s.gsub(/\s+/, '').downcase
          end
        end
      end

      # phone_param
      phone_param = user_params[:phone].to_s.gsub(/\s+/, '')
      if phone_param.blank?
        render json: { errors: { phone: "Phone cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        # phone_format
        phone_format = /\A(2541|2547)\d{8}\z/
        unless phone_param.match(phone_format)
          render json: { errors: { phone: "Invalid phone format!"}}, status: :unprocessable_entity
          return
        else
          # phone should not exist
          phone = User.find_by(phone: phone_param)
          if phone
            render json: { errors: { phone: "Phone already taken!"}}, status: :unprocessable_entity
          return
          end
        end

        phone_param = phone_param.to_s.gsub(/\s+/, '')
        
      end

      # password_param and password_confirmation_param
      password_param = user_params[:password]
      password_confirmation_param = user_params[:password_confirmation]

      if password_param.present? || password_confirmation_param.present?
        if !password_param && password_confirmation_param.present?
          render json: { errors: { password: "Password is required!"}}, status: :unprocessable_entity
          return
        elsif password_param.present? && !password_confirmation_param
          render json: { errors: { password_confirmation: "Password confirmation is required!"}}, status: :unprocessable_entity
          return
        end

        # password_length
        if password_param.length < 8
          render json: { errors: { password: "Password should have at least 8 characters!"}}, status: :unprocessable_entity
          return
        end

        # password_mismatch
        if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
          render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
          return
        end

        # password_format
        unless password_param =~ /[A-Za-z]/ && password_param =~ /\d/
          render json: { errors: { password: "Password must include both letters and numbers!"}}, status: :unprocessable_entity
          return
        end

        password_param = password_param
        password_confirmation_param = password_confirmation_param
      end

      # create_user
      created_user = User.create(
        email: email_param,
        phone: phone_param,
        password: password_param,
        password_confirmation: password_confirmation_param,
        flag: "Admin"
      )

      if created_user
        render json: { message: "User created successfully!"}, status: :created
      else
        render json: { error: "Error creating user!", info: created_user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view single_user
  def single_user
    begin
      user = User.find_by(id: params[:id])
      if user
        info = user.as_json(except: [:created_at, :updated_at, :password_digest])
        render json: info, status: :ok
      else
        render json: { error: "User not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view all_users
  def all_users
    begin
      users = User.all
      if users.empty?
        render json: { error: "Empty List" }, status: :not_found
        return
      else
        info = users.map do |user|
          user.as_json(except: [:created_at, :updated_at, :password_digest])
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # update_user
  def update_user
    begin
      user = User.find_by(id: params[:id])
      if user
        user_info = {}

        # email_param
        email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
        if email_param.present?
          # email_format
          email_format = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/i
          unless email_param.match(email_format)
            render json: { errors: { email: "Invalid Email Format!"}},  status: :unprocessable_entity
            return
          else
            # email should not exist
            existing_user = User.find_by(email: email_param)
            if existing_user && existing_user.id != user.id
              render json: { errors: { email: "Email Already Exists!"}}, status: :unprocessable_entity
              return
            end
          end
          email_param = email_param.to_s.gsub(/\s+/, '').downcase
          user_info[:email] = email_param
        end

        # phone_param
        phone_param = user_params[:phone].to_s.gsub(/\s+/, '')
        if phone_param.present?

          # phone_format
          phone_format = /\A(2541|2547)\d{8}\z/
          unless phone_param.match(phone_format)
            render json: { errors: { phone: "Invalid phone format!"}}, status: :unprocessable_entity
            return
          end

          # phone should not exist
          existing_user = User.find_by(phone: phone_param)
          if existing_user && existing_user.id != user.id
            render json: { errors: { phone: "User with the email already exists!"}}, status: :unprocessable_entity
            return
          end

          phone_param = phone_param.to_s.gsub(/\s+/, '')
          user_info[:phone] = phone_param
        end

        # password_param and password_confirmation_param
        password_param = user_params[:password]
        password_confirmation_param = user_params[:password_confirmation]

        if password_param.present? || password_confirmation_param.present?
          if !password_param && password_confirmation_param.present?
            render json: { errors: { password: "Password is required!"}}, status: :unprocessable_entity
            return
          elsif password_param.present? && !password_confirmation_param
            render json: { errors: { password_confirmation: "PAssword confiramtion is required!"}}, status: :unprocessable_entity
            return
          end

          # password mismatch
          if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
            render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
            return
          end

          # password length
          if password_param.length < 8
            render json: { errors: { password: "Password should have at least 8 characters!"}}, status: :unprocessable_entity
            return
          end

          # both letters and numbers
          unless password_param.match(/[A-Za-z]/) && password_param.match(/\d/)
            render json: { errors: { password: "Password should have both letters and numbers!"}}, status: :unprocessable_entity
            return
          end

          password_param = password_param
          password_confirmation_param = password_confirmation_param

          user_info[:password] = password_param
          user_info[:password_confirmation] = password_confirmation_param
        end

        # update_user
        updated_user = user.update(
          user_info
        )

        if updated_user
          render json: { message: "User Updated!"}, status: :ok
        else
          render json: { error: "Error updating user!", info: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "User not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_user
  def delete_user
    begin
      user = User.find_by(id: params[:id])
      if user
        user_email = user.email
        user.destroy
        render json: { message: "User with email #{user_email} deleted successfully!"}, status: :ok
      else
        render json: { error: "User not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # user_login
  def user_login
    begin
      email_param = params[:email].to_s.gsub(/\s+/, '').downcase
      password_param = params[:password]

      if email_param.present? || password_param.present?
        if !email_param && password_param.present?
          render json: { errors: { email: "Email is required!"}}, status: :unprocessable_entity
          return
        elsif email_param.present? && !password_param
          render json: { errors: { password: "PAssword is required!"}}, status: :unprocessable_entity
          return
        end
      end
      user = User.find_by(email: email_param)
      if user
        auth = user.authenticate(password_param)
        if auth
          rendered_info = {}

          flag = user.flag
          if flag == 'Candidate'
            rendered_info = rendered_info.merge({
              id: user.candidate.id,
              first_name: user.candidate.first_name,
              last_name: user.candidate.last_name,
              username: user.candidate.username,
              date_of_birth: user.candidate.date_of_birth,
              email: user.candidate.user.email,
              phone: user.candidate.user.phone
            })
          elsif flag == 'Recruiter'
            rendered_info = rendered_info.merge({
              id: user.recruiter.id,
              first_name: user.recruiter.first_name,
              last_name: user.recruiter.last_name,
              username: user.recruiter.username,
              company: user.recruiter.company,
              email: user.recruiter.user.email,
              phone: user.recruiter.user.phone
            })
          else
            rendered_info = rendered_info.merge({
              id: user.id
            })
          end
          access_token = JsonWebToken.encode_token(user.id, user.flag, 30.minutes.from_now)
          refresh_token = JsonWebToken.encode_token(user.id, user.flag, 24.hours.from_now)

          rendered_info[:access_token] = access_token
          rendered_info[:refresh_token] = refresh_token
          rendered_info[:flag] = flag

          # send email
          UserLogin.send_login_email(user)

          render json: rendered_info, status: :ok
        else
          render json: { errors: { password: "Invalid password!"}}, status: :unprocessable_entity
          return
        end
      else
        render json: { errors: { email: "Email not found!"}}, status: :not_found
      end

    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # refresh_token
  def refresh_token
    begin
      auth_header = request.headers['Authorization']
      refresh_token = auth_header.split(' ').last

      if refresh_token.blank?
        render json: { errors: { refresh_token: "Refresh token is needed!"}}, status: :unauthorized
        return
      end


      decoded_token = JsonWebToken.decode_token(refresh_token)

      user_id = decoded_token[:user_id]
      flag = decoded_token[:flag]
      
      new_access_token = JsonWebToken.encode_token(user_id, flag,  30.minutes.from_now)
      new_refresh_token = JsonWebToken.encode_token(user_id, flag, 24.hours.from_now)

      render json: { 
        new_access_token: new_access_token,
        new_refresh_token: new_refresh_token,
        flag: flag
      }
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # google_login

  require 'httparty'
  def google_login
    token = params[:token]

    user_info = HTTParty.get("https://www.googleapis.com/oauth2/v3/userinfo",
      headers: { "Authorization" => "Bearer #{token}" })

    if user_info.code == 200
      email = user_info["email"]
      name = user_info["name"]

      user = User.find_or_create_by(email: email) do |u|
        u.name = name
        u.password = SecureRandom.hex(10)
      end

      access_token = JsonWebToken.encode_token(user.id, 30.minutes.from_now)
      refresh_token = JsonWebToken.encode_token(user.id, 24.hours.from_now)

      render json: { message: "Google Login Successful!", access_token: access_token, refresh_token: refresh_token, user: user }, status: :ok
    else
      render json: { error: "Invalid Google token" }, status: :unauthorized
    end
  end


  # privately hold user_params
  private
  def user_params
    params.require(:user).permit(:email, :phone, :flag, :password, :password_confirmation)
  end
end
