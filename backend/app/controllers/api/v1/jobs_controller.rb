class Api::V1::JobsController < ApplicationController


  # before_action
  before_action :get_access_token

  # create_job
  def create_job
    begin
      # create_job
      # job_params

      # title_param
      title_param = job_params[:title]
      if title_param.blank?
        render json: { errors: { title: "Title cannot be empty!"}}, status: :unprocessable_entity
        return
      else
        title_param = title_param.titleize
      end

      # description_param
      description_param = job_params[:description]
      if description_param.blank?
        render json: { errors: { description: "Job description needed!"}}, status: :unprocessable_entity
        return
      else
        description_param = description_param.capitalize
      end

      # create_job
      created_job = Job.new(
        recruiter_id: @recruiter_id,
        title: title_param,
        description: description_param
      )

      if created_job.save
        render json: { message: "Job created successfully!" }, status: :created
      else
        render json: { error: "Error creating job!", info: created_job.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :unprocessable_entity
    end
    
  end

  # view single_job
  def single_job
    begin
      job = Job.find_by(id: params[:id])

      if job

        # should only have my id
        my_id = job.recruiter.id
        unless my_id == @recruiter_id
          render json: { error: "You cannot only view a job you have created!" }, status: :unauthorized
          return
        end

        recruiter_company = job.recruiter.company
        recruiter_username = job.recruiter.username
        recruiter_first_name = job.recruiter.first_name
        recruiter_last_name = job.recruiter.last_name
        recruiter_email = job.recruiter.user.email
        recruiter_phone = job.recruiter.user.phone

        info = job.as_json(except: [:created_at, :updated_at]).merge({ 

          recruiter_company: recruiter_company,
          recruiter_username: recruiter_username,
          recruiter_first_name: recruiter_first_name,
          recruiter_last_name: recruiter_last_name,
          recruiter_email: recruiter_email,
          recruiter_phone: recruiter_phone

        })

        render json: info, status: :ok
      else
        render json: { error: "Job not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view all_jobs
  def all_jobs
    begin

      if @flag == 'Admin'
        jobs = Job.all
      elsif (@flag == 'Recruiter')
        jobs = Job.where(recruiter_id: @current_user.recruiter.id)
      end

      # jobs = Job.where(recruiter_id: @recruiter_id)
      
      if jobs.empty?
        render json: { error: "Empty List" }, status: :not_found
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

  # update_job
  def update_job
    begin
      job = Job.find_by(id: params[:id])

      if job

        # update a job with your id
        my_id = job.recruiter.id
        unless my_id == @recruiter_id
          render json: { error: "You can only update a job with your id." }, status: :unauthorized
          return
        end
        updated_job_info = {}

        # title_param
        title_param = job_params[:title]
        if title_param.present?
          title_param = title_param
          updated_job_info[:title] = title_param
        end

        # description_param
        description_param = job_params[:description]
        if description_param.present?
          description_param = description_param
          updated_job_info[:description] = description_param
        end

        # update_job
        updated_job = job.update(
          updated_job_info
        )

        if updated_job
          render json: { message: "Job updated successfully!" }, status: :ok
        else
          render json: { error: "Error updating job!", info: job.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Job not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_job
  def delete_job
    begin
      job = Job.find_by(id: params[:id])
      if job

        # should only have your id
        my_id = job.recruiter.id
        unless my_id == @recruiter_id
          render json: { error: "You can only delete your job." }, status: :unauthorized
          return
        end
        
        job_title = job.title
        job.destroy
        render json: { message: "Job with title '#{job_title}' deleted successfully!" }, status: :ok
      else
        render json: { error: "Job not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # job_candidates
  def job_candidates
    begin
      jobs = Job.where(recruiter_id: @recruiter_id)
      applications = Application.where(job_id: jobs.pluck(:id)).includes(:candidate)

      if applications.empty?
        render json: { error: "No candidates have applied yet!" }, status: :not_found
        return
      else
        info = applications.map do |application|

          candidate_email = application.candidate.user.email
          candidate_phone = application.candidate.user.phone
          candidate_first_name = application.candidate.first_name
          candidate_last_name = application.candidate.last_name
          candidate_username = application.candidate.username

          application.as_json(except: [:created_at, :updated_at]).merge({
            candidate_email: candidate_email,
            candidate_phone: candidate_phone,
            candidate_first_name: candidate_first_name,
            candidate_last_name: candidate_last_name,
            candidate_username: candidate_username
          })
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # privately hold job_params
  private

  def get_access_token
    auth_header = request.headers['Authorization']
    if auth_header.present? && auth_header.starts_with?('Bearer ')
      @access_token = auth_header.split(' ').last

      begin
        decoded_token = JsonWebToken.decode_token(@access_token)
        @user_id = decoded_token[:user_id]
        @current_user = User.find_by(id: @user_id)

        @flag = @current_user.flag

        if @flag == 'Recruiter'
          @recruiter_id = @current_user.recruiter.id
        elsif @flag == 'Admin'
          nil
        end

        # if @current_user && @current_user.flag == 'Recruiter'
        #   @recruiter_id = @current_user.recruiter.id
        # else
        #   render json: { error: "User not found!" }, status: :not_found
        # end
      rescue
      end
      
    else
      render json: { error: "Token invalid or not found!" }, status: :unauthorized
    end
  end

  def job_params
    params.require(:job).permit(:recruiter_id, :title, :description)
  end
end
