class Api::V1::UsersController < ApplicationController

  include RegexHelper
  include SearchHelper
  include SortHelper

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
        normalized_email = email_format(email_param)

        # email should not exist
        users = User.all.order(:email).to_a
        conflict = email_search(users, normalized_email)
        if conflict
          render json: conflict, status: :unprocessable_entity
          return
        end

        email_param = normalized_email
      end

      # phone_param
      phone_param = user_params[:phone].to_s.gsub(/\s+/, '')
      if phone_param.blank?
        render json: { errors: { phone: "Phone cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        # phone_format
        normalized_phone = phone_format(phone_param)
        
        # email should not exist
        users = User.all.order(:phone).to_a
        conflict = phone_search(users, normalized_phone)
        if conflict
          render json: conflict, status: :unprocessable_entity
          return
        end

        phone_param = normalized_phone
        
      end

      # password_param and password_confirmation_param
      password_param = user_params[:password]
      password_confirmation_param = user_params[:password_confirmation]

      conflict = password_regex(password_param, password_confirmation_param)
      if conflict
        render json: conflict, status: :unprocessable_entity
        return
      end
      password_param = password_param
      password_confirmation_param = password_confirmation_param

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
      users = User.all.order(:id).to_a
      target_id = params[:id].to_i

      user = binary_user_search(users, target_id)

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
      users = User.all.order(:email).to_a
      sorted_array = sort_user_email(users)
      if sorted_array.empty?
        render json: { error: "Empty List" }, status: :not_found
        return
      else
        info = sorted_array.map do |user|
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
      users = User.all.order(:id).to_a
      target_id = params[:id].to_i

      user = binary_user_search(users, target_id)

      if user
        user_info = {}

        # email_param
        email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
        if email_param.present?
          # email_format
          normalized_email = email_format(email_param)

          if normalized_email.is_a?(Hash) && normalized_email[:errors]
            render json: normalized_email, status: :unprocessable_entity
            return
          end

          conflict = binary_email_search(User.all.order(:email).to_a, normalized_email, user.id)

          if conflict
            render json: conflict, status: :unprocessable_entity
            return
          end

          email_param = normalized_email
          user_info[:email] = email_param
        end

        # phone_param
        phone_param = user_params[:phone].to_s.gsub(/\s+/, '')
        if phone_param.present?
          normalized_phone = phone_format(phone_param)

          if normalized_phone.is_a?(Hash)
            render json: normalized_phone, status: :unprocessable_entity
            return
          end

          conflict = binary_phone_search(User.all.order(:phone).to_a, normalized_phone, user.id)

          if conflict
            render json: conflict, status: :unprocessable_entity
            return
          end

          phone_param = normalized_phone
          user_info[:phone] = phone_param
          
        end

        # password_param and password_confirmation_param
        password_param = user_params[:password]
        password_confirmation_param = user_params[:password_confirmation]

        conflict = password_regex(password_param, password_confirmation_param)

        if conflict
          render json: conflict, status: :unprocessable_entity
          return
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
      users = User.all.order(:id).to_a
      target_id = params[:id].to_i

      user = binary_user_search(users, target_id)

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
      users = User.all.order(:email).to_a

      email_param = params[:email].to_s.gsub(/\s+/, '').downcase
      password_param = params[:password]

      if email_param.present? && password_param.blank?
        render json: { errors: { password: "Password is required!"}}, status: :unprocessable_entity
        return
      elsif email_param.blank? && password_param.present?
        render json: { errors: { email: "Email is required!"}}, status: :unprocessable_entity
        return
      end

      user = login_email_search(users, email_param)
      if user

        rendered_info = {}
        flag = user.flag

        access_token = JsonWebToken.encode_token(user.id, user.flag, 30.minutes.from_now)
        refresh_token = JsonWebToken.encode_token(user.id, user.flag, 24.hours.from_now)

        if flag == 'Admin'
          rendered_info[:id] = user.id
          rendered_info[:email] = user.email
          rendered_info[:phone] = user.phone
          rendered_info[:flag] = user.flag
          rendered_info[:access_token] = access_token
          rendered_info[:refresh_token] = refresh_token

        elsif flag == 'Candidate'
          rendered_info[:id] = user.candidate.user.id
          rendered_info[:email] = user.candidate.user.email
          rendered_info[:phone] = user.candidate.user.phone
          rendered_info[:flag] = user.candidate.user.flag
          rendered_info[:access_token] = access_token
          rendered_info[:refresh_token] = refresh_token
          rendered_info[:first_name] = user.candidate.first_name
          rendered_info[:last_name] = user.candidate.last_name
          rendered_info[:username] = user.candidate.username
          rendered_info[:date_of_birth] = user.candidate.date_of_birth
          
        elsif flag == 'Recruiter'
          rendered_info[:id] = user.recruiter.user.id
          rendered_info[:email] = user.recruiter.user.email
          rendered_info[:phone] = user.recruiter.user.phone
          rendered_info[:flag] = user.recruiter.user.flag
          rendered_info[:access_token] = access_token
          rendered_info[:refresh_token] = refresh_token
          rendered_info[:first_name] = user.recruiter.first_name
          rendered_info[:last_name] = user.recruiter.last_name
          rendered_info[:username] = user.recruiter.username
          rendered_info[:company] = user.recruiter.company
        end

        auth = user.authenticate(password_param)
        if auth
          # send email
          UserLogin.send_login_email(user)
          render json: rendered_info, status: :ok
        else
          render json: { errors: { password: "Invalid Password!"}}, status: :unprocessable_entity
          return
        end
      else
        render json: { error: "User not found!"}, status: :not_found
        return
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
