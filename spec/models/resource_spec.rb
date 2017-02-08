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
        @pkey1  = Digest::MD5.hexdigest("query|#{nil}|pname1")
        @pkey2  = Digest::MD5.hexdigest("query|#{nil}|pname2")
        @param1 = FactoryGirl.create(:parameter, name: "pname1", key: @pkey1, location: "query", version: 1, position: 1, resource: resource)
        @param2 = FactoryGirl.create(:parameter, name: "pname2", key: @pkey2, location: "query", version: 1, position: 2, resource: resource)
      end

      it 'When an inout has changed, A new inout attributes should be creating' do
        resource_data["params"] = [
          {
            "required"  => true, 
            "array"     => false,
            "location"  => "query",
            "name"      => @param1.name, 
            "summary"   => @param1.summary
          }, {
            "array"     => false, 
            "type"      => "Number", 
            "location"  => "query",
            "required"  => false, 
            "default"   => "0", 
            "name"      => "num", 
            "summary"   => "A Number value"
          }, {
            "array"     => false, 
            "type"      => "Number", 
            "location"  => "query",
            "required"  => true, 
            "default"   => "0", 
            "name"      => @param2.name, 
            "summary"   => @param2.summary
          }
        ]
        changed_attrs, new_attrs = resource.changes_by_expect(resource_data)

        expect(changed_attrs[:parameters_attributes].length).to eq 3
        expect(changed_attrs[:parameters_attributes].map { |e| e[:position] }).to match_array [12, 22, 22]
        expect(changed_attrs[:parameters_attributes]).to include({ id: @param2.id, position: 22, has_discarded_flag: true })
      end

      it 'When only an inout descriptions has changed, A new inout should not be creating' do
        resource_data["params"] = [
          {
            "required"  => true, 
            "array"     => false,
            "name"      => @param1.name, 
            "summary"   => @param1.summary,
            "location"  => "query",
            "descriptions" => [['aaa']]
          }, {
            "array"     => false, 
            "required"  => true, 
            "location"  => "query",
            "name"      => @param2.name, 
            "summary"   => @param2.summary
          }
        ]
        changed_attrs, new_attrs = resource.changes_by_expect(resource_data)

        expect(changed_attrs[:parameters_attributes].length).to eq 1
        expect(changed_attrs[:parameters_attributes][0]).to have_key(:id)
        expect(changed_attrs[:parameters_attributes][0]).to have_key(:descriptions_attributes)
      end
    end

    context 'The resource without inout' do
      it 'The length of parameters_attributes should be 2 when add 2 params' do
        resource_data["params"] = [
          {
            "array"     => false, 
            "type"      => "Boolean", 
            "location"  => "query",
            "required"  => true, 
            "name"      => "ok", 
            "summary"   => "A boolean value"
          }, {
            "array"     => false, 
            "type"      => "Number", 
            "location"  => "query",
            "required"  => false, 
            "default"   => "0", 
            "name"      => "num", 
            "summary"   => "A Number value"
          }
        ]
        changed_attrs, new_attrs = resource.changes_by_expect(resource_data)

        expect(changed_attrs[:parameters_attributes].length).to eq 2
        expect(changed_attrs[:parameters_attributes].map { |e| e[:position] }).to eq [0, 1000]
      end

      it 'The parameters_attributes should be have 2 class params when add 2 class params' do
        resource_data["params"] = [
          {
            "array"     => false, 
            "type"      => "Boolean", 
            "location"  => "query",
            "required"  => true, 
            "name"      => "ok", 
            "summary"   => "A boolean value"
          }
        ]
        resource_data["responses"] = [
          {
            "array"     => false, 
            "type"      => "Number", 
            "location"  => "query",
            "required"  => false, 
            "default"   => "0", 
            "name"      => "num", 
            "summary"   => "A Number value"
          }
        ]
        changed_attrs, new_attrs = resource.changes_by_expect(resource_data)

        expect(changed_attrs[:parameters_attributes].length).to eq 1
        expect(changed_attrs[:parameters_attributes].map { |e| e[:position] }).to eq [0]

        expect(changed_attrs[:responses_attributes].length).to eq 1
        expect(changed_attrs[:responses_attributes].map { |e| e[:position] }).to eq [0]
      end
    end

  end

end
