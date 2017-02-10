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
        "summary": "this is a summary"
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
end
