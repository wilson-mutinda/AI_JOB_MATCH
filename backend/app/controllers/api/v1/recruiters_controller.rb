class Api::V1::RecruitersController < ApplicationController

  # create_recruiter
  def create_recruiter
    begin

      # user_params

      created_user_info = {}

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
        created_user_info[:email] = email_param
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

        phone_param = phone_param.gsub(/\s+/, '')

        created_user_info[:phone] = phone_param

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

        created_user_info[:password] = password_param
        created_user_info[:password_confirmation] = password_confirmation_param
      end

      # recruiter_params

      created_recruiter_info = {}

      # first_name_param
      first_name_param = recruiter_params[:first_name].to_s.gsub(/\s+/, '').downcase
      if first_name_param.blank?
        render json: { errors: { first_name: "First_name is required!"}}, status: :unprocessable_entity
        return
      else
        first_name_param = first_name_param.to_s.gsub(/\s+/, '').capitalize
        created_recruiter_info[:first_name] = first_name_param
      end

      # last_name_param
      last_name_param = recruiter_params[:last_name].to_s.gsub(/\s+/, '').downcase
      if last_name_param.blank?
        render json: { errors: { last_name: "Last name cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        last_name_param = last_name_param.to_s.gsub(/\s+/, '').capitalize
        created_recruiter_info[:last_name] = last_name_param
      end

      # username_param
      username_param = recruiter_params[:username]
      if username_param.blank?
        render json: { errors: { username: "USername cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        # username should not exist
        existing_username = Recruiter.find_by(username: username_param)
        if existing_username
          render json: { errors: { username: "Username already exists!"}}, status: :unprocessable_entity
          return
        end

        username_param = username_param
        created_recruiter_info[:username] = username_param
      end

      # company_param
      company_param = recruiter_params[:company].to_s.gsub(/\s+/, '').downcase
      if company_param.blank?
        render json: { errors: { company: "Company cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        company_param = company_param.to_s.gsub(/\s+/, '').capitalize
        created_recruiter_info[:company] = company_param
      end

      # create_user
      created_user = User.create(
        email: email_param,
        phone: phone_param,
        password: password_param,
        password_confirmation: password_confirmation_param,
        flag: "Recruiter"
      )

      if created_user
        # create_recruiter
        created_recruiter = Recruiter.create(
          user_id: created_user.id,
          first_name: first_name_param,
          last_name: last_name_param,
          username: username_param,
          company: company_param
        )

        if created_recruiter
          render json: { message: "Recruiter created successfully!"}, status: :created
        else
          render json: { error: "Error creating recruiter!", info: created_recruiter.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Error creating user!", info: created_user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view single_recruiter
  def single_recruiter
    begin
      recruiter = Recruiter.find_by(id: params[:id])
      if recruiter
        
        email = recruiter.user.email
        phone = recruiter.user.phone
        flag = recruiter.user.flag

        info = recruiter.as_json(except: [:created_at, :updated_at]).merge({ email: email, phone: phone, flag: flag})
        render json: info, status: :ok
      else
        render json: { error: "Recruiter not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view all_recruiters
  def all_recruiters
    begin
      recruiters = Recruiter.all
      if recruiters.empty?
        render json: { error: "Empty List!"}, status: :not_found
        return
      else
        info = recruiters.map do |recruiter|

          email = recruiter.user.email
          phone = recruiter.user.phone
          flag = recruiter.user.flag

          recruiter.as_json(except: [:created_at, :updated_at]).merge({ email: email, phone: phone, flag: flag})
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # update_recruiter
  def update_recruiter
    begin
      recruiter = Recruiter.find_by(id: params[:id])
      if recruiter
        # user_params

        user_info = {}

        # email_param
        email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
        if email_param.present?
          # email_format
          email_format = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/i
          unless email_param.match(email_format)
            render json: { errors: { email: "Invalid email format!"}}, status: :unprocessable_entity
            return
          end

          # email should not exist
          existing_email = User.find_by(email: email_param)
          if existing_email && existing_email.id != recruiter.user.id
            render json: { errors: { email: "Email is already taken"}}, status: :unprocessable_entity
            return
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
          existing_phone = User.find_by(phone: phone_param)
          if existing_phone && existing_phone.id != recruiter.user.id
            render json: { errors: { phone: "Phone already taken!"}}, status: :unprocessable_entity
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
            render json: { errors: { password: "Password is needed!"}}, status: :unprocessable_entity
            return
          elsif password_param.present? && !password_confirmation_param
            render json: { errors: { password_confirmation: "Password confirmation required!"}}, status: :unprocessable_entity
            return
          end

          # password mismatch
          if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
            render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
            return
          end

          # password length
          if password_param.length < 8
            render json: { errors: { password: "PAssword should have at least 8 characters!"}}, status: :unprocessable_entity
            return
          end

          # password should have both letters and numbers
          unless password_param.match(/[A-Za-z]/) && password_param.match(/\d/)
            render json: { errors: { password: "Password should have both numbers and letters!"}}, status: :unprocessable_entity
            return
          end

          password_param = password_param
          password_confirmation_param = password_confirmation_param

          user_info[:password] = password_param
          user_info[:password_confirmation] = password_confirmation_param

        end

        # recruiter_params

        recruiter_info = {}

        # first_name_param
        first_name_param = recruiter_params[:first_name].to_s.gsub(/\s+/, '').downcase
        if first_name_param.present?
          first_name_param = first_name_param.to_s.gsub(/\s+/, '').capitalize
          recruiter_info[:first_name] = first_name_param
        end

        # last_name_param
        last_name_param = recruiter_params[:last_name].to_s.gsub(/\s+/, '').downcase
        if last_name_param.present?
          last_name_param = last_name_param.to_s.gsub(/\s+/, '').capitalize
          recruiter_info[:last_name] = last_name_param
        end

        # username_param
        username_param = recruiter_params[:username].to_s.gsub(/\s+/, '')
        if username_param.present?
          # username should not exist for another user
          existing_username = Recruiter.find_by(username: username_param)
          if existing_username && existing_username.id != recruiter.id
            render json: { errors: { username: "Username already taken!"}}, status: :unprocessable_entity
            return
          end
          username_param = username_param.to_s.gsub(/\s+/, '')
          recruiter_info[:username] = username_param
        end

        # company_param
        company_param = recruiter_params[:company].to_s.gsub(/\s+/, '').downcase
        if company_param.present?
          company_param = company_param.to_s.gsub(/\s+/, '').capitalize
          recruiter_info[:company] = company_param
        end

        # update_user
        updated_user = recruiter.user.update(
          user_info
        )

        if updated_user
          # update_recruiter
          updated_recruiter = recruiter.update(
            recruiter_info
          )

          if updated_recruiter
            render json: { message: "Recruiter updated successfully!" }, status: :ok
          else
            render json: { error: "Error updating recruiter!", info: recruiter.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "Error updating user!", info: recruiter.user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Recruiter not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_recruiter
  def delete_recruiter
    begin
      recruiter = Recruiter.find_by(id: params[:id])
      if recruiter
        recruiter_email = recruiter.user.email
        # delete recruiter first
        recruiter.destroy

        # delete user
        recruiter.user.destroy

        render json: { message: "Recruiter of email #{recruiter_email} deleted successfully!"}, status: :ok
      else
        render json: { error: "Recruiter not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view my_candidates
  def my_candidates
    begin
      
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # privately hold user_params and recruiter_params
  private

  def user_params
    params.require(:user).permit(:email, :phone, :password, :password_confirmation, :flag)
  end

  def recruiter_params
    params.require(:recruiter).permit(:user_id, :first_name, :last_name, :username, :company)
  end

end
