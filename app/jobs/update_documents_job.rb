class UpdateDocumentsJob < ApplicationJob
  queue_as :transcription

  def perform(tape_id)
    Tape.transcription(tape_id)
  end
end
