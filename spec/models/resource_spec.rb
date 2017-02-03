require 'rails_helper'

RSpec.describe Resource, type: :model do
  
  let(:document) { FactoryGirl.create(:document) }
  let(:resource) { FactoryGirl.create(:resource, method: "POST", path: "/api/v2/b_res", document: document) }
  let(:resource_data) do
    {
      "method"  => "post", 
      "path"    => "/api/v2/b_res", 
      "summary" => "Get list of A"
    }
  end

  describe '.changes_by_expect' do
    context 'The resource have 2 param inout' do
      before(:example) do
        @change = FactoryGirl.create(:change, version: "0.1.0.0", project: document.project)
        @pkey1  = Digest::MD5.hexdigest("param|#{nil}|pname1")
        @pkey2  = Digest::MD5.hexdigest("param|#{nil}|pname2")
        @param1 = FactoryGirl.create(:inout, name: "pname1", key: @pkey1, clazz: :param, version: 1, position: 1, resource: resource)
        @param2 = FactoryGirl.create(:inout, name: "pname2", key: @pkey2, clazz: :param, version: 1, position: 2, resource: resource)
      end

      it 'When an inout has changed, A new inout attributes should be creating' do
        resource_data["params"] = [
          {
            "required"  => true, 
            "array"     => false,
            "name"      => @param1.name, 
            "summary"   => @param1.summary
          }, {
            "array"     => false, 
            "type"      => "Number", 
            "required"  => false, 
            "default"   => "0", 
            "name"      => "num", 
            "summary"   => "A Number value"
          }, {
            "array"     => false, 
            "type"      => "Number", 
            "required"  => true, 
            "default"   => "0", 
            "name"      => @param2.name, 
            "summary"   => @param2.summary
          }
        ]
        attrs = resource.changes_by_expect(resource_data)

        expect(attrs[:inouts_attributes].length).to eq 3
        expect(attrs[:inouts_attributes].map { |e| e[:position] }).to match_array [12, 22, 22]
        expect(attrs[:inouts_attributes]).to include({ id: @param2.id, position: 22, has_discarded_flag: true })
      end

      it 'When only an inout descriptions has changed, A new inout should not be creating' do
        resource_data["params"] = [
          {
            "required"  => true, 
            "array"     => false,
            "name"      => @param1.name, 
            "summary"   => @param1.summary,
            "descriptions" => [['aaa']]
          }, {
            "array"     => false, 
            "required"  => true, 
            "name"      => @param2.name, 
            "summary"   => @param2.summary
          }
        ]
        attrs = resource.changes_by_expect(resource_data)

        expect(attrs[:inouts_attributes].length).to eq 1
        expect(attrs[:inouts_attributes][0]).to have_key(:id)
        expect(attrs[:inouts_attributes][0]).to have_key(:descriptions_attributes)
      end
    end

    context 'The resource without inout' do
      it 'The length of inouts_attributes should be 2 when add 2 params' do
        resource_data["params"] = [
          {
            "array"     => false, 
            "type"      => "Boolean", 
            "required"  => true, 
            "name"      => "ok", 
            "summary"   => "A boolean value"
          }, {
            "array"     => false, 
            "type"      => "Number", 
            "required"  => false, 
            "default"   => "0", 
            "name"      => "num", 
            "summary"   => "A Number value"
          }
        ]
        attrs = resource.changes_by_expect(resource_data)

        expect(attrs[:inouts_attributes].length).to eq 2
        expect(attrs[:inouts_attributes].map { |e| e[:position] }).to eq [0, 1000]
      end

      it 'The inouts_attributes should be have 2 class params when add 2 class params' do
        resource_data["params"] = [
          {
            "array"     => false, 
            "type"      => "Boolean", 
            "required"  => true, 
            "name"      => "ok", 
            "summary"   => "A boolean value"
          }
        ]
        resource_data["headers"] = [
          {
            "array"     => false, 
            "type"      => "Number", 
            "required"  => false, 
            "default"   => "0", 
            "name"      => "num", 
            "summary"   => "A Number value"
          }
        ]
        attrs = resource.changes_by_expect(resource_data)

        expect(attrs[:inouts_attributes].length).to eq 2
        expect(attrs[:inouts_attributes].map { |e| e[:position] }).to eq [0, 0]
        expect(attrs[:inouts_attributes].map { |e| e[:clazz] }).to eq [:header, :param]
      end
    end

  end

end
