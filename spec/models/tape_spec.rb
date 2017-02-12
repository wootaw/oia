require 'rails_helper'

RSpec.describe Tape, type: :model do

  let(:bad_content) { "{ a: 1, b: 2" }
  let(:invalid_content1) do
    %q{
      {
        "name": "doc",
        "summary": "this is a summary"
      }
    }
  end
  let(:invalid_content2) do
    %q{
      [{
        "summary": "this is a summary"
      }]
    }
  end
  let(:normal_content1) do
    %q{
      [{
        "name": "doc",
        "summary": "Summary"
      }]
    }
  end

  describe '.data' do
    context 'Exception content of tape' do
      it 'When a bad content in the tape that state should be broken' do
        tape = FactoryGirl.create(:tape, content: bad_content)
        data = tape.data
        expect(data).to eq nil
        expect(tape.schema).to eq nil
        expect(tape.state).to eq "broken"
      end

      it 'When the invalid_content1 in the tape that state should be invalided'do
        tape = FactoryGirl.create(:tape, content: invalid_content1)
        data = tape.data
        expect(data).to eq nil
        expect(tape.state).to eq "invalided"
      end

      it 'When the invalid_content2 in the tape that state should be invalided'do
        tape = FactoryGirl.create(:tape, content: invalid_content2)
        data = tape.data
        expect(data).to eq nil
        expect(tape.state).to eq "invalided"
      end
    end

    context 'Normal content of tape' do
      it 'When the normal_content1 in the tape that state should be good' do
        tape = FactoryGirl.create(:tape, content: normal_content1)
        data = tape.data
        expect(data).not_to eq nil
        expect(tape.schema).to eq "v1.0"
        expect(tape.state).to eq "good"
      end
    end
  end

  describe '.transcription' do
    context 'Exception content of tape' do
      before(:each) do
        @tape1 = FactoryGirl.create(:tape, content: bad_content)
        @tape2 = FactoryGirl.create(:tape, content: invalid_content1)
      end

      it 'When a bad content in the tape, the document count of project not should be change' do
        Tape.transcription(@tape1.project_id)

        @tape1.reload
        expect(@tape1.project.documents.length).to eq 0
        expect(@tape1.state).to eq 'broken'
      end

      it 'When a invalid content in the tape, the document count of project not should be change' do
        Tape.transcription(@tape2.project_id)

        @tape2.reload
        expect(@tape2.project.documents.length).to eq 0
        expect(@tape2.state).to eq 'invalided'
      end
    end

    context 'Normal content of tape' do
      before(:each) do
        @tape = FactoryGirl.create(:tape, content: normal_content1)
      end

      it 'When without new document, the document count of project not should be change' do
        FactoryGirl.create(:document, project: @tape.project, name: 'doc', summary: 'Summary')
        Tape.transcription(@tape.project_id)

        @tape.reload
        expect(@tape.project.documents.length).to eq 1
        expect(@tape.state).to eq 'finished'
      end

      it 'When add new document, the tape should be update version' do
        FactoryGirl.create(:document, project: @tape.project, name: 'doc2', summary: 'Summary2')
        FactoryGirl.create(:change, project: @tape.project, version: 1)
        Tape.transcription(@tape.project_id)

        @tape.reload
        expect(@tape.project.documents.length).to eq 2
        expect(@tape.state).to eq 'finished'
        expect(@tape.version).to eq 2
      end
    end
  end
end
