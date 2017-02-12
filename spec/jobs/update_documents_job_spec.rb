require 'rails_helper'

RSpec.describe UpdateDocumentsJob, type: :job do
  describe '.perform' do
    it 'should work' do
      expect(Tape).to receive(:transcription).with(234).once
      UpdateDocumentsJob.perform_now(234)
    end
  end
end
