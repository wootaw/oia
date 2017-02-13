module Api
  module V1
    class DocumentsController < Api::V1::ApplicationController

      def create
        requires! :project_key
        requires! :sign
        requires! :data
        optional! :schema, default: 'v1.0'

        project = Project.find_by!(access_key: params[:project_key])
        digest  = OpenSSL::Digest.new("sha1")
        docs    = Base64.urlsafe_decode64(params[:data])
        binary  = OpenSSL::HMAC.digest(digest, project.secret_key, docs)

        if Base64.urlsafe_encode64(binary) == params[:sign]
          tape = project.tapes.create(content: docs)
          job  = UpdateDocumentsJob.perform_later(project.id)
          tape.update_attributes(job_id: job.provider_job_id)
        else
          raise AccessDenied
        end
      end

      protected

    end
  end
end