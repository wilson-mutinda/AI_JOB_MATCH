class Api::V1::CandidatesController < ApplicationController

  # create_candidate
  def create_candidate
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

      # candidate_params

      created_candidate_info = {}

      # first_name_param
      first_name_param = candidate_params[:first_name].to_s.gsub(/\s+/, '').downcase
      if first_name_param.blank?
        render json: { errors: { first_name: "First name cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        first_name_param = first_name_param.to_s.gsub(/\s+/, '').capitalize
        created_candidate_info[:first_name] = first_name_param
      end

      # last_name_param
      last_name_param = candidate_params[:last_name].to_s.gsub(/\s+/, '').downcase
      if last_name_param.blank?
        render json: { errors: { last_name: "Last name cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        last_name_param = last_name_param.to_s.gsub(/\s+/, '').capitalize
        created_candidate_info[:last_name] = last_name_param
      end

      # username_param
      username_param = candidate_params[:username].to_s.gsub(/\s+/, '')
      if username_param.blank?
        render json: { errors: { username: "USername cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        # username should not exist
        existing_username = Candidate.find_by(username: username_param)
        if existing_username
          render json: { errors: { username: "Username already exists!"}}, status: :unprocessable_entity
          return
        end
        username_param = username_param.to_s.gsub(/\s+/, '')
        created_candidate_info[:username] = username_param
      end

      # dob_param
      dob_param = candidate_params[:date_of_birth]
      if dob_param.blank?
        render json: { errors: { date_of_birth: "Date of birth cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        # dob should not be in future
        now = Date.today
        parsed_date = Date.parse(dob_param)
        if parsed_date >= now
          render json: { errors: { date_of_birth: "Date of birth cannot be in fiture!"}}, status: :unprocessable_entity
          return
        end

        dob_param = dob_param
        created_candidate_info[:date_of_birth] = dob_param
      end

      # create_candidate
      created_user = User.create(
        created_user_info.merge({ flag: "Candidate"})
      )

      if created_user
        # create_candidate
        created_candidate = Candidate.create(
          created_candidate_info.merge({user_id: created_user.id})
        )

        if created_candidate
          render json: { message: "Candidate created successfully!" }, status: :created
        else
          render json: { error: "Error creating candidate!", info: created_candidate.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Error creating user!", info: created_user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view single_candidate
  def single_candidate
    begin
      candidate = Candidate.find_by(id: params[:id])
      if candidate
        
        email = candidate.user.email
        phone = candidate.user.phone
        flag = candidate.user.flag

        info = candidate.as_json(except: [:created_at, :updated_at]).merge({ email: email, phone: phone, flag: flag})
        render json: info, status: :ok
      else
        render json: { error: "Candidate not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view all_candidates
  def all_candidates
    begin
      candidates = Candidate.all
      if candidates.empty?
        render json: { error: "Empty List" }, status: :not_found
        return
      else
        info = candidates.map do |candidate|

          email = candidate.user.email
          phone = candidate.user.phone
          flag = candidate.user.flag

          candidate.as_json(except: [:created_at, :updated_at]).merge({ email: email, phone: phone, flag: flag})
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # update_candidate
  def update_candidate
    begin
      candidate = Candidate.find_by(id: params[:id])
      if candidate
        # user_params

        updated_user_info = {}
        
        # email_param
        email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
        if email_param.present?
          # email_format
          email_format = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/i
          unless email_param.match(email_format)
            render json: { errors: { email: "Invalid Email Format!"}}, status: :unprocessable_entity
            return
          end

          # email should not exist
          existing_email = User.find_by(email: email_param)
          if existing_email && existing_email.id != candidate.user.id
            render json: { errors: { email: "Email has been taken!"}}, status: :unprocessable_entity
            return
          end

          email_param = email_param.to_s.gsub(/\s+/, '').downcase
          updated_user_info[:email] = email_param
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
          if existing_phone && existing_phone.id != candidate.user.id
            render json: { errors: { phone: "Phone already exists!"}}, status: :unprocessable_entity
            return
          end

          phone_param = phone_param.to_s.gsub(/\s+/, '')
          updated_user_info[:phone] = phone_param
        end

        # password_param and password_confirmation_param
        password_param = user_params[:password]
        password_confirmation_param = user_params[:password_confirmation]

        if password_param.present? || password_confirmation_param.present?
          
          if !password_param && password_confirmation_param.present?
            render json: { errors: { password: "Password is needed!"}}, status: :unprocessable_entity
            return
          elsif password_param.present? && !password_confirmation_param
            render json: { errors: { password_confirmation: "Password confirmation is needed!"}}, status: :unprocessable_entity
            return
          end

          # password_length
          if password_param.length < 8
            render json: { errors: { password: "PAssword should have at least 8 characters!"}}, status: :unprocessable_entity
            return
          end

          # password mismatch
          if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
            render json: { errors: { password_confirmation: "PAssword Mismatch!"}}, status: :unprocessable_entity
            return
          end

          # password should have both letters and numbers
          unless password_param.match(/[A-Za-z]/) && password_param.match(/\d/)
            render json: { errors: { password: "Password should have both letters and numbers!"}}, status: :unprocessable_entity
            return
          end

          password_param = password_param
          password_confirmation_param = password_confirmation_param

          updated_user_info[:password] = password_param
          updated_user_info[:password_confirmation] = password_confirmation_param
        end

        # candidate_params

        updated_candidate_info = {}

        # first_name_param
        first_name_param = candidate_params[:first_name].to_s.gsub(/\s+/, '').downcase
        if first_name_param.present?
          first_name_param = first_name_param.to_s.gsub(/\s+/, '').capitalize
          updated_candidate_info[:first_name] = first_name_param
        end

        # last_name_param
        last_name_param = candidate_params[:last_name].to_s.gsub(/\s+/, '').downcase
        if last_name_param.present?
          last_name_param = last_name_param.to_s.gsub(/\s+/, '').capitalize
          updated_candidate_info[:last_name] = last_name_param
        end

        # username_param
        username_param = candidate_params[:username]
        if username_param.present?
          # username should not exist
          existing_username = Candidate.find_by(username: username_param)
          if existing_username && existing_username.id != candidate.id
            render json: { errors: { username: "sername already exists!"}}, status: :unprocessable_entity
            return
          end
          username_param = username_param
          updated_candidate_info[:username] = username_param
        end

        # dob_param
        dob_param = candidate_params[:date_of_birth]
        if dob_param.present?
          # date should not be in future
          now = Date.today
          parsed_date = Date.parse(dob_param)
          if parsed_date >= now
            render json: { errors: { date_of_birth: "Date cannot be in future!"}}, status: :unprocessable_entity
            return
          end

          dob_param = dob_param
          updated_candidate_info[:date_of_birth] = dob_param
        end

        # update_user
        updated_user = candidate.user.update(
          updated_user_info
        )

        if updated_user
          # update_candidate
          updated_candidate = candidate.update(
            updated_candidate_info
          )

          if updated_candidate
            render json: { message: "Candidate updated" }, status: :ok
          else
            render json: { error: "Error updating candidate!", info: candidate.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "Error updating user!", info: candidate.user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Candidate not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_candidate
  def delete_candidate
    begin
      candidate = Candidate.find_by(id: params[:id])
      if candidate
        candidate_email = candidate.user.email

        # delete candidate first
        candidate.destroy

        # delete_user
        candidate.user.destroy

        render json: { message: "Candidate with email #{candidate_email} deleted successfully!" }, status: :ok
      else
        render json: { error: "Candidate not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view posted_jobs
  def posted_jobs
    begin
      jobs = Job.all
      if jobs.empty?
        render json: { error: "Empty List!" }, status: :not_found
        return
      else
        info = jobs.map do |job|

          recruiter_company = job.recruiter.company
          recruiter_username = job.recruiter.username
          recruiter_first_name = job.recruiter.first_name
          recruiter_last_name = job.recruiter.last_name
          recruiter_email = job.recruiter.user.email
          recruiter_phone = job.recruiter.user.phone

          job.as_json(except: [:created_at, :updated_at]).merge({
            recruiter_company: recruiter_company,
            recruiter_username: recruiter_username,
            recruiter_first_name: recruiter_first_name,
            recruiter_last_name: recruiter_last_name,
            recruiter_email: recruiter_email,
            recruiter_phone: recruiter_phone
          })
          
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # privately hold user_params and candidate_params
  private

  def user_params
    params.require(:user).permit(:email, :phone, :password, :password_confirmation, :flag)
  end

  def candidate_params
    params.require(:candidate).permit(:user_id, :first_name, :last_name, :username, :date_of_birth)
  end
end
