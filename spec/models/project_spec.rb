require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:docs) do
    [
      { # the first document
        :summary => "Document One", 
        :name => "document1", 
        :descriptions => [
          ["This row is a description of this document.", "Detail:"], 
          ["This is document of number one.", "It do not anything. Just to test."], 
          ["  This is the second paragraph of this document description.", "It do not anything, too."]
        ], 
        :resources => [
          { 
            :method => "get", 
            :path => "/api/v1/a_res/:num_a", 
            :summary => "Get list of A", 
            :descriptions => [
              ["This resource can get list of A. It can paginate."], 
              ["see more:"], 
              ["    This is the second paragraph of this resource description.", "Can not have more describe."]
            ], 
            :params => [
              { 
                :array => false, 
                :type => "Boolean", 
                :location => "query",
                :required => true, 
                :name => "is", 
                :summary => "A boolean value", 
                :descriptions => [
                  ["More description", "@res_param_section", "Very very much"]
                ]
              }, {
                :array => false, 
                :type => "Number", 
                :location => "query",
                :required => false, 
                :default => "0", 
                :name => "num", 
                :summary => "A Number value"
              }, {
                :options => ["a", "b", "c"], 
                :array => false, 
                :type => "String", 
                :location => "query",
                :required => true, 
                :name => "str", 
                :summary => "Allowed values"
              }, {
                :array => false, 
                :type => "Number", 
                :location => "path",
                :required => false, 
                :name => "num_a", 
                :summary => "A Number value"
              }, {
                :array => false, 
                :type => "Number", 
                :location => "query",
                :required => false, 
                :name => "num_b", 
                :summary => "A Number value, too."
              }, {
                :array => false, 
                :type => "Number", 
                :location => "query",
                :required => false, 
                :name => "num_c", 
                :summary => "A Number value, again."
              }, {
                :array => false, 
                :type => "Number", 
                :location => "query",
                :required => false, 
                :name => "num_x", 
                :summary => "Number X"
              }, {
                :array => false, 
                :type => "Number", 
                :location => "query",
                :required => false, 
                :name => "num_y", 
                :summary => "Number Y"
              }, {
                :array => false, 
                :type => "Number", 
                :location => "query",
                :required => false, 
                :default => "3", 
                :name => "num_z", 
                :summary => "Number Z"
              }, {
                :array => false, 
                :type => "String", 
                :location => "query",
                :required => false, 
                :name => "str_a", 
                :summary => "A String value"
              }, {
                :array => false, 
                :type => "String", 
                :location => "query",
                :required => false, 
                :name => "str_b", 
                :summary => "A String value, too."
              }, {
                :array => false, 
                :type => "String", 
                :location => "query",
                :required => false, 
                :name => "str_c", 
                :summary => "A String value, again."
              }, {
                :array => true, 
                :type => "String", 
                :location => "query",
                :required => false, 
                :name => "str_x", 
                :summary => "X"
              }, {
                :array => false, 
                :type => "String", 
                :location => "query",
                :required => false, 
                :name => "str_y", 
                :summary => "Y"
              }, {
                :required => false, 
                :location => "query",
                :name => "z", 
                :summary => "Z"
              }, {
                :array => false, 
                :type => "Object", 
                :location => "body",
                :required => true, 
                :name => "obj", 
                :summary => "An Object value"
              }, {
                :array => false, 
                :type => "String", 
                :location => "body",
                :required => true, 
                :parent => ["obj"], 
                :name => "name", 
                :summary => "name of Object"
              }, {
                :array => false, 
                :type => "Number", 
                :location => "body",
                :required => false, 
                :default => "0", 
                :parent => ["obj"], 
                :name => "count", 
                :summary => "count of Object"
              }, {
                :array => true, 
                :type => "Object", 
                :location => "body",
                :required => true, 
                :name => "data", 
                :summary => "An Array value"
              }, {
                :array => false, 
                :type => "Boolean", 
                :location => "body",
                :required => true, 
                :parent => ["data"], 
                :name => "ok", 
                :summary => "ok?"
              }, {
                :options => ["2", "3", "4"], 
                :array => true, 
                :type => "Number", 
                :location => "body",
                :required => false, 
                :parent => ["data"], 
                :name => "sum", 
                :summary => "Sum"
              }
            ], 
            :binds => [
              {
                :scope => "param", 
                :command => "least", 
                :vars => ["num_a,num_b,num_c", "1"]
              }, {
                :command => "only", 
                :vars => ["num_a,num_b,num_c", "2"]
              }, {
                :scope => "param", 
                :command => "given", 
                :vars => ["str_a", "str_b,str_c"]
              }, {
                :command => "entire", 
                :vars => ["str_x,str_y,z"]
              }
            ]
          }, {
            :method => "post", 
            :path => "/api/v1/a_res", 
            :summary => "Create an A resource", 
            :state => {
              :name => "coming", 
              :summary => "Coming Soon", 
              :descriptions => [
                ["This resource is not finish"]
              ]
            }, 
            :params => [
              {
                :required => false, 
                :location => "header",
                :name => "a", 
                :summary => "A"
              }, {
                :options => ["a", "b", "c"], 
                :array => false, 
                :type => "String", 
                :location => "header",
                :required => true, 
                :name => "b", 
                :summary => "B"
              }, {
                :options => ["1", "2", "3"], 
                :array => true, 
                :type => "Number", 
                :location => "header",
                :required => true, 
                :name => "c", 
                :summary => "C", 
                :descriptions => [
                  ["More description about header C.", "Can't write more, really"]
                ]
              }, {
                :array => false, 
                :type => "Object", 
                :location => "body",
                :required => true, 
                :name => "obj", 
                :summary => "An Object value"
              }, {
                :array => false, 
                :type => "String", 
                :location => "body",
                :required => true, 
                :parent => ["obj"], 
                :name => "name", 
                :summary =>"name of Object"
              }, {
                :array => false, 
                :type => "Number", 
                :location => "body",
                :required => false, 
                :default => "0", 
                :parent => ["obj"], 
                :name => "count", 
                :summary => "count of Object"
              }, {
                :array => false, 
                :type => "Boolean", 
                :location => "query",
                :required => true, 
                :name => "ok", 
                :summary => "A boolean value"
              }
            ], 
            :responses => [
              {
                :location => "header",
                :required => false, 
                :name => "a", 
                :summary => "A"
              }, {
                :options => ["a", "b", "c"], 
                :array => false, 
                :type => "String", 
                :group => "201", 
                :location => "body",
                :required => true, 
                :name => "b", 
                :summary => "B", 
                :descriptions => [
                  ["This is the first row.", "This is the second row."], 
                  ["```ruby"], 
                  ["  b = \"a\""], 
                  ["  if b == \"a\""], 
                  ["    puts \"Ha Ha Ha\""], 
                  ["  end"], 
                  ["```"], 
                  ["This is the tail.", "This is the last row."]
                ]
              }, {
                :options => ["1", "2", "3"], 
                :array => true, 
                :type => "Number", 
                :group => "201", 
                :location => "body",
                :required => true, 
                :name => "c", 
                :summary => "C", 
                :descriptions => [
                  ["More description about response C.", "Can't write more about response C."]
                ]
              }, {
                :required => true, 
                :group => "403", 
                :location => "body",
                :name => "code", 
                :summary => "Error code", 
                :descriptions => [
                  [], 
                  ["- 100 Message number one"], 
                  ["- 101 Message number two"], 
                  ["- 102 Message number three"], 
                  ["This is the last row."]
                ]
              }, {
                :required => true, 
                :name => "msg", 
                :group => "403", 
                :location => "body",
                :summary => "Error message", 
                :descriptions => [
                  ["This is a row detail,", "See more:"], 
                  ["- Message one"], 
                  ["  1. First row"], 
                  ["  2. Second row"], 
                  ["  3. Third row"], 
                  ["- Message two"], 
                  ["This is the error description tail.", "This is the last row."]
                ]
              }
            ]
          }
        ]
      }, { # the second document
        :summary => "Document One", 
        :name => "document2", 
        :descriptions => [
          ["This is document of number two"],
          ["More description about response C.", "Can't write more about response C."]
        ], 
        :resources => [
          {
            :method => "post", 
            :path => "/api/v2/b_res", 
            :summary => "Get list of A", 
            :state => {
              :name => "coming", 
              :summary => "This resource will be coming soon", 
              :descriptions => [
                ["The first row description of resource state", "The second row description of resource state."], 
                ["The third row description of resource state"]
              ]
            }
          }
        ]
      }, { # the third document
        :summary => "Other Document", 
        :name => "document3", 
        :state => {
          :name => "deprecated", 
          :summary => "", 
          :descriptions => [
            ["The first row description of document state."], 
            ["The second row description of document state.", "The third row description of document state"]
          ]
        }
      }
    ]
  end

  let(:project_user) { FactoryGirl.create(:project_user) }
  let(:project_team) { FactoryGirl.create(:project_team) }

  describe '.attach_version' do
    it 'Should be delete all the key names is has_discarded_flag then add discard_version in the attributes' do
      attrs = [{ 
        id: 1,
        resources_attributes: [{
          id: 2,
          inouts_attributes: [{
            id: 33,
            position: 22,
            has_discarded_flag: true
          }]
        }]
      }]

      project_user.attach_version(attrs, 3)

      expect(attrs[0][:resources_attributes][0][:inouts_attributes][0]).to eq({ id: 33, position: 22, discard_version: 3 })
    end
  end

  describe ".update_version" do

    context "Document" do
      it "Should be create 2 document when 2 new document attributes" do
        project_user.update_version(docs[1..-1])
        project_user.save

        project_user.reload
        expect(project_user.documents.count).to eq 2
      end

      it "Should be create 1 document when 1 new document attributes" do
        FactoryGirl.create(:document, name: "document2", project: project_user)
        FactoryGirl.create(:document, project: project_team)
        
        expect(project_user.documents.count).to eq 1

        project_user.update_version(docs[1..-1])
        project_user.save
        expect(project_user.documents.count).to eq 2
      end

    end

    context "Change" do
      it "Initial document version number should be 1" do
        project_user.update_version(docs[1..-1])
        project_user.save
        project_user.reload
        expect(project_user.documents.first.version).to eq 1
        expect(project_user.lastest_change.version).to eq "0.1.0.0"
      end

      it "The increment of new document version number should be 1" do
        FactoryGirl.create(:document, name: "document2", project: project_user, version: 1)
        FactoryGirl.create(:document, project: project_team)
        FactoryGirl.create(:change, version: "0.1.0.0", project: project_user)
        project_user.update_attributes(minor_version: 1, patch_version: 0)

        project_user.update_version(docs[1..-1])
        project_user.save
        project_user.reload

        expect(project_user.documents.map(&:version)).to match_array [1, 2]
        expect(project_user.lastest_change.version).to eq "0.2.0.0"
      end

      it "The version number should remain unchanged when without document changes" do
        FactoryGirl.create(:document, name: "document3", project: project_user, version: 1)
        FactoryGirl.create(:document, project: project_team)
        FactoryGirl.create(:change, version: "0.1.9.0", project: project_user)
        project_user.update_attributes(minor_version: 1, patch_version: 9)

        project_user.update_version([docs[2]])
        project_user.save
        project_user.reload

        expect(project_user.documents.map(&:version)).to match_array [1]
        expect(project_user.lastest_change.version).to eq "0.1.9.0"
      end

      it 'The patch version number should be increased by 1 when creating a resource' do
        FactoryGirl.create(:document, name: "document2", project: project_user, version: 1)
        FactoryGirl.create(:document, project: project_team)
        FactoryGirl.create(:change, version: "0.1.9.0", project: project_user)
        project_user.update_attributes(minor_version: 1, patch_version: 9)

        project_user.update_version([docs[1]])
        project_user.save
        project_user.reload

        expect(project_user.documents.map(&:version)).to match_array [1]
        expect(project_user.lastest_change.version).to eq "0.1.10.0"
      end
    end

    context "Resource" do
      it "Should be create 2 resources for the first document" do
        project_user.update_attributes(minor_version: 1, patch_version: 0)
        project_user.update_version([docs[0]])
        project_user.save

        expect(project_user.documents.first.resources.count).to eq 2

        doc1 = project_user.documents.first
        project_user.reload
        expect(project_user.lastest_change.parts(doc1, :resources).map(&:position)).to eq [0, 1000]
        expect(project_user.lastest_change.version).to eq "0.2.0.0"
      end

      it "Should be update resource summary when it have new summary" do
        doc1   = FactoryGirl.create(:document, name: "document1", project: project_user, version: 1)
        change = FactoryGirl.create(:change, version: "0.1.0.0", project: project_user)
        key1   = Digest::MD5.hexdigest("GET|/api/v1/a_res/:num_a")
        key2   = Digest::MD5.hexdigest("POST|/api/v1/a_res")

        res1 = FactoryGirl.create(:resource, method: "GET", path: "/api/v1/a_res/:num_a", key: key1, position: 1, version: change.version, document: doc1)
        res2 = FactoryGirl.create(:resource, method: "POST", path: "/api/v1/a_res", key: key2, position: 2, version: change.version, document: doc1)
        project_user.update_attributes(minor_version: 1, patch_version: 0)

        docs[0][:resources].each { |r| r.delete_if { |d| [:params, :headers, :responses].include?(d) } }
        project_user.update_version([docs[0]])
        project_user.save

        project_user.reload
        res1.reload
        res2.reload
        expect(res1.summary).to eq "Get list of A"
        expect(res2.summary).to eq "Create an A resource"
        expect(project_user.lastest_change.version).to eq "0.1.0.1"
      end

      it "The position of discarded resource description should be can expand" do
        doc1   = FactoryGirl.create(:document, name: "document1", project: project_user, version: 1)
        change1 = FactoryGirl.create(:change, version: "0.1.0.0", project: project_user)
        change2 = FactoryGirl.create(:change, version: "0.1.1.0", project: project_user)
        key1   = Digest::MD5.hexdigest("GET|/api/v1/a_res")
        key2   = Digest::MD5.hexdigest("POST|/api/v1/a_res")
        res1 = FactoryGirl.create(:resource, method: "GET", path: "/api/v1/a_res", key: key1, position: 1, version: change1.version, document: doc1)
        res2 = FactoryGirl.create(:resource, method: "POST", path: "/api/v1/a_res", key: key2, position: 2, version: change1.version, document: doc1)

        FactoryGirl.create(:description, content: "9", key: Digest::MD5.hexdigest("9"), position: 0, version: change1.position, owner: res2)
        FactoryGirl.create(:description, content: "8", key: Digest::MD5.hexdigest("8"), position: 1, version: change1.position, owner: res2)
        FactoryGirl.create(:description, content: "7", key: Digest::MD5.hexdigest("7"), position: 2, version: change1.position, discard_version: change2.position, owner: res2)
        FactoryGirl.create(:description, content: "6", key: Digest::MD5.hexdigest("6"), position: 2, version: change2.position, owner: res2)
        FactoryGirl.create(:description, content: "5", key: Digest::MD5.hexdigest("5"), position: 3, version: change1.position, discard_version: change2.position, owner: res2)

        attrs = docs[0]
        attrs[:resources][1][:descriptions] = [["9"], ["0"], ["8"], ["1"], ["6"], ["2"], ["3"]]

        project_user.update_version([docs[0]])
        project_user.save

        project_user.reload
        change1.reload
        change2.reload
        lastest = project_user.lastest_change
        expect(lastest.parts(res2, :descriptions).map(&:content)).to eq ["9", "0", "8", "1", "6", "2", "3"]
        expect(change2.parts(res2, :descriptions).map(&:content)).to eq ["9", "8", "6"]
        expect(change1.parts(res2, :descriptions).map(&:content)).to eq ["9", "8", "7", "5"]
      end

      it 'The resource 2 of position and summary should be changed' do
        doc1   = FactoryGirl.create(:document, name: "document1", project: project_user, version: 1)
        change1 = FactoryGirl.create(:change, version: "0.1.0.0", project: project_user)
        key1   = Digest::MD5.hexdigest("GET|/api/v1/a_res")
        key2   = Digest::MD5.hexdigest("POST|/api/v1/a_res")
        res1 = FactoryGirl.create(:resource, method: "GET", path: "/api/v1/a_res", key: key1, position: 1, version: change1.version, document: doc1)
        res2 = FactoryGirl.create(:resource, method: "POST", path: "/api/v1/a_res", key: key2, position: 2, version: change1.version, document: doc1)

        new_res = {
          :method => "delete", 
          :path => "/api/v2/b_res", 
          :summary => "Get list of A"
        }
        docs[0][:resources].insert(1, new_res)
        project_user.update_version([docs[0]])
        project_user.save

        project_user.reload
        lastest = project_user.lastest_change
        expect(lastest.parts(doc1, :resources).map(&:method)).to eq ["GET", "DELETE", "POST"]
        res2.reload
        expect(res2.summary).to eq "Create an A resource"
      end
    end

    context "Description" do
      before(:example) do
        @doc3   = FactoryGirl.create(:document, name: "document3", project: project_user, version: 1)
        @change = FactoryGirl.create(:change, version: "0.1.0.0", project: project_user)
      end

      it "Description position interval is 1000" do
        attrs = docs[2]
        attrs[:descriptions] = [["9"], ["6"]]

        project_user.update_version([attrs])
        project_user.save

        project_user.reload
        expect(project_user.lastest_change.parts(@doc3, :descriptions).map(&:position)).to eq [0, 1000]
      end

      it "Insert and Remove" do
        FactoryGirl.create(:description, content: "9", key: Digest::MD5.hexdigest("9"), position: 0, version: @change.position, owner: @doc3)
        FactoryGirl.create(:description, content: "8", key: Digest::MD5.hexdigest("8"), position: 1000, version: @change.position, owner: @doc3)
        FactoryGirl.create(:description, content: "7", key: Digest::MD5.hexdigest("7"), position: 2000, version: @change.position, owner: @doc3)

        attrs = docs[2]
        attrs[:descriptions] = [["9"], ["6"], ["5"], ["7"]]

        project_user.update_version([attrs])
        project_user.save

        project_user.reload
        @change.reload
        lastest = project_user.lastest_change
        expect(lastest.parts(@doc3, :descriptions).map(&:content)).to eq ["9", "6", "5", "7"]
        expect(@change.parts(@doc3, :descriptions).map(&:content)).to eq ["9", "8", "7"]
      end

      it "Position should be can expand" do
        FactoryGirl.create(:description, content: "9", key: Digest::MD5.hexdigest("9"), position: 0, version: @change.position, owner: @doc3)
        FactoryGirl.create(:description, content: "8", key: Digest::MD5.hexdigest("8"), position: 1, version: @change.position, owner: @doc3)
        FactoryGirl.create(:description, content: "7", key: Digest::MD5.hexdigest("7"), position: 2, version: @change.position, owner: @doc3)

        attrs = docs[2]
        attrs[:descriptions] = [["9"], ["8"], ["6"], ["5"], ["4"], ["7"]]

        project_user.update_version([attrs])
        project_user.save

        project_user.reload
        @change.reload
        lastest = project_user.lastest_change
        expect(@change.parts(@doc3, :descriptions).last.position).to eq 42
      end

      it "The position of discarded description should be can expand" do
        change2 = FactoryGirl.create(:change, version: "0.1.1.0", project: project_user)

        FactoryGirl.create(:description, content: "9", key: Digest::MD5.hexdigest("9"), position: 0, version: @change.position, owner: @doc3)
        FactoryGirl.create(:description, content: "8", key: Digest::MD5.hexdigest("8"), position: 1, version: @change.position, owner: @doc3)
        FactoryGirl.create(:description, content: "7", key: Digest::MD5.hexdigest("7"), position: 2, version: @change.position, discard_version: change2.position, owner: @doc3)
        FactoryGirl.create(:description, content: "6", key: Digest::MD5.hexdigest("6"), position: 2, version: change2.position, owner: @doc3)
        FactoryGirl.create(:description, content: "5", key: Digest::MD5.hexdigest("5"), position: 3, version: @change.position, discard_version: change2.position, owner: @doc3)

        attrs = docs[2]
        attrs[:descriptions] = [["9"], ["0"], ["8"], ["1"], ["6"], ["2"], ["3"]]

        project_user.update_version([attrs])
        project_user.save

        project_user.reload
        @change.reload
        lastest = project_user.lastest_change
        expect(lastest.parts(@doc3, :descriptions).map(&:content)).to eq ["9", "0", "8", "1", "6", "2", "3"]
        expect(change2.parts(@doc3, :descriptions).map(&:content)).to eq ["9", "8", "6"]
        expect(@change.parts(@doc3, :descriptions).map(&:content)).to eq ["9", "8", "7", "5"]
      end
    end

  end

  describe '.append_collaborators' do

    it 'should be able to back the former collaborators' do
      collaborator_user = create(:collaborator_user, state: :left)

      collaborator_user.project.append_collaborators([collaborator_user.member.email])
      collaborator_user.reload
      expect(collaborator_user.joined?).to be_truthy
    end

    it 'should be able to invite signed users' do
      user = create(:user)

      project_user.append_collaborators([user.email])
      expect(project_user.collaborators.count).to eq 1
    end

    it 'should be able to back the declined invitation' do
      collaborator_invitation = create(:collaborator_invitation, state: :declined)

      collaborator_invitation.project.append_collaborators([collaborator_invitation.member.email])
      collaborator_invitation.reload
      expect(collaborator_invitation.mounted?).to be_truthy
    end

    it 'should be able to invite unsigned users by email' do
      project_user.append_collaborators(["abc@website.com"])
      expect(project_user.collaborators.count).to eq 1
    end
  end

end
