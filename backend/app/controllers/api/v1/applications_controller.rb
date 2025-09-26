class Api::V1::ApplicationsController < ApplicationController

  before_action :get_candidate_id

  # create_application
  def create_application
    begin

      # job_id
      job_id = application_params[:job_id]

      job = Job.find_by(id: job_id)

      unless job
        render json: { errors: { job_id: "Job not found!"}}, status: :not_found
        return
      end
      
      # application_params
      # curriculum_vitae_param
      curriculum_vitae_param = application_params[:curriculum_vitae]
      if curriculum_vitae_param.blank?
        render json: { errors: { curriculum_vitae: "CV is needed!"}}, status: :unprocessable_entity
        return
      else
        curriculum_vitae = curriculum_vitae_param
      end

      # create_application
      created_application = Application.create(
        job_id: job_id,
        candidate_id: @candidate_id,
        date_of_application: Date.today,
        curriculum_vitae: curriculum_vitae
      )

      if created_application
        render json: { message: "Application created successfully!" }, status: :created
      else
        render json: { error: "Error creating application", info: created_application.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view single_application
  def single_application
    begin
      application = Application.find_by(id: params[:id])
      if application

        cv_url = url_for(application.curriculum_vitae)

        job_title = application.job.title
        job_description = application.job.description
        job_recruiter_username = application.job.recruiter.username
        job_recruiter_company = application.job.recruiter.company
        job_recruiter_first_name = application.job.recruiter.first_name
        job_recruiter_last_name = application.job.recruiter.last_name
        job_recruiter_email = application.job.recruiter.user.email
        job_recruiter_phone = application.job.recruiter.user.phone

        job_candidate_first_name = application.candidate.first_name
        job_candidate_last_name = application.candidate.last_name
        job_candidate_username = application.candidate.username
        job_candidate_date_of_birth = application.candidate.date_of_birth
        job_candidate_email = application.candidate.user.email
        job_candidate_phone = application.candidate.user.phone

        info = application.as_json(except: [:created_at, :updated_at]).merge({ 

        cv_url: cv_url,
          job_title: job_title,
          job_description: job_description,
          job_recruiter_username: job_recruiter_username,
          job_recruiter_company: job_recruiter_company,
          job_recruiter_first_name: job_recruiter_first_name,
          job_recruiter_last_name: job_recruiter_last_name,
          job_recruiter_email: job_recruiter_email,
          job_recruiter_phone: job_recruiter_phone,

          job_candidate_first_name: job_candidate_first_name,
          job_candidate_last_name: job_candidate_last_name,
          job_candidate_username: job_candidate_username,
          job_candidate_date_of_birth: job_candidate_date_of_birth,
          job_candidate_email: job_candidate_email,
          job_candidate_phone: job_candidate_phone

        })
        render json: info, status: :ok
      else
        render json: { error: "Appliocation not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view all_applications
  def all_applications
    begin
      applications = Application.all
      if applications.empty?
        render json: { error: "Empty List!" }, status: :not_found
        return
      else
        info = applications.map do |application|

          cv_url = url_for(application.curriculum_vitae)
          job_title = application.job.title
          job_description = application.job.description
          job_recruiter_username = application.job.recruiter.username
          job_recruiter_company = application.job.recruiter.company
          job_recruiter_first_name = application.job.recruiter.first_name
          job_recruiter_last_name = application.job.recruiter.last_name
          job_recruiter_email = application.job.recruiter.user.email
          job_recruiter_phone = application.job.recruiter.user.phone

          job_candidate_first_name = application.candidate.first_name
          job_candidate_last_name = application.candidate.last_name
          job_candidate_username = application.candidate.username
          job_candidate_date_of_birth = application.candidate.date_of_birth
          job_candidate_email = application.candidate.user.email
          job_candidate_phone = application.candidate.user.phone

          application.as_json(except: [:created_at, :updated_at]).merge({

            cv_url: cv_url,
            job_title: job_title,
            job_description: job_description,
            job_recruiter_username: job_recruiter_username,
            job_recruiter_company: job_recruiter_company,
            job_recruiter_first_name: job_recruiter_first_name,
            job_recruiter_last_name: job_recruiter_last_name,
            job_recruiter_email: job_recruiter_email,
            job_recruiter_phone: job_recruiter_phone,

            job_candidate_first_name: job_candidate_first_name,
            job_candidate_last_name: job_candidate_last_name,
            job_candidate_username: job_candidate_username,
            job_candidate_date_of_birth: job_candidate_date_of_birth,
            job_candidate_email: job_candidate_email,
            job_candidate_phone: job_candidate_phone

          })
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # update_application
  def update_application
    begin
      application = Application.find_by(id: params[:id])
      if application
        # curriculum_vitae_param
        curriculum_vitae_param = application_params[:curriculum_vitae]
        if curriculum_vitae_param.present?
          curriculum_vitae_param = curriculum_vitae_param
        end

        # update_application
        updated_application = application.update(
          curriculum_vitae: curriculum_vitae_param
        )

        if updated_application
          render json: { message: "Application updated successfully!" }, status: :ok
        else
          render json: { error: "Error updating application", info: application.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Application not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_application
  def delete_application
    begin
      application = Application.find_by(id: params[:id])
      if application
        application.destroy
        render json: { message: "Application deleted successfully!" }, status: :ok
      else
        render json: { error: "Application cannot be found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # candidate_applications
  def candidate_applications
    begin
      applications = Application.where(candidate_id: @candidate_id)
                                .order(created_at: :desc)
      if applications.empty?
        render json: { error: "You have not yet applied applied to any jobs." }, status: :not_found
        return
      else
        info = applications.map do |application|

          job_title = application.job.title
          job_description = application.job.description
          cv_url = url_for(application.curriculum_vitae)
          recruiter_email = application.job.recruiter.user.email
          recruiter_phone = application.job.recruiter.user.phone
          recruiter_company = application.job.recruiter.company
          recruiter_first_name = application.job.recruiter.first_name
          recruiter_last_name = application.job.recruiter.last_name
          recruiter_username = application.job.recruiter.username

          candidate_email = application.candidate.user.email
          candidate_phone = application.candidate.user.phone
          candidate_username = application.candidate.username
          candidate_date_of_birth = application.candidate.date_of_birth

          application.as_json(except: [:created_at, :updated_at]).merge({
            job_title: job_title,
            job_description: job_description,
            cv_url: cv_url,
            recruiter_email: recruiter_email,
            recruiter_phone: recruiter_phone,
            recruiter_company: recruiter_company,
            recruiter_first_name: recruiter_first_name,
            recruiter_last_name: recruiter_last_name,
            recruiter_username: recruiter_username,

            candidate_email: candidate_email,
            candidate_phone: candidate_phone,
            candidate_username: candidate_username,
            candidate_date_of_birth: candidate_date_of_birth
          })
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # privately store application_params
  private

  def get_candidate_id
    request_header = request.headers['Authorization']
    access_token = request_header.split(' ').last
    
    begin
      decoded_token = JsonWebToken.decode_token(access_token)
      @user_id = decoded_token[:user_id]
      @current_user = User.find_by(id: @user_id)
      if @current_user && @current_user.flag == 'Candidate'
        @candidate_id = @current_user.candidate.id
      else
        render json: { error: "User not found!" }, status: :not_found
        return
      end
    rescue 
    end
    
  end

  def application_params
    params.require(:application).permit(:candidate_id, :job_id, :curriculum_vitae, :date_of_application)
  end

end
