require 'rails_helper'

RSpec.describe 'API v1', 'documents', type: :request do
  include ActiveJob::TestHelper

  after do
    clear_enqueued_jobs
  end 

  describe 'PUT /api/v1/documents' do
    context 'Invaild project access key' do
      let(:invaild_params) do
        {
          project_key: 'invaild_access_key',
          sign: 'sign',
          data: '{}'
        }
      end

      it 'should 404' do
        post '/api/v1/documents', params: invaild_params
        expect(response.status).to eq(404)
      end
    end
    
    context 'Normal project access key' do
      let(:docs) { '{}' }
      let(:normal_params) do 
        { 
          project_key: @project.access_key,
          data: Base64.urlsafe_encode64(docs)
        }
      end

      before(:example) do
        @project = create(:project)
        digest   = OpenSSL::Digest.new("sha1")
        @binary  = OpenSSL::HMAC.digest(digest, @project.secret_key, docs)
      end

      it 'When the data not match sign, should 403' do
        normal_params[:sign] = 'sign'
        post '/api/v1/documents', params: normal_params
        expect(response.status).to eq(403)
      end

      it 'When the data match sign, should 204' do
        normal_params[:sign] = Base64.urlsafe_encode64(@binary)
        post '/api/v1/documents', params: normal_params
        expect(response.status).to eq(204)
      end

      it 'When the data match sign, should exists UpdateDocumentsJob' do
        normal_params[:sign] = Base64.urlsafe_encode64(@binary)
        assert_enqueued_with(job: UpdateDocumentsJob, args: [@project.id], queue: 'test.transcription') do
          post '/api/v1/documents', params: normal_params
        end
      end
      
    end

  end

end
