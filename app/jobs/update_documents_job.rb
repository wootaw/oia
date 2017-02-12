class UpdateDocumentsJob < ApplicationJob
  queue_as :transcription

  def perform(project_id)
    Tape.transcription(project_id)
  end
end
