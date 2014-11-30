#Copyright 2014 Bruno Goes de Meira
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

require 'spec_helper'

describe GSimpleApi::Manager do
  let(:name) { "test" }
  let(:version) { "1.0.0" }
  let(:api) { "plus" }
  let(:client_id) { "123152412412" }
  let(:client_secret) { "sad3121232" }
  let(:params) do
    {
        :name => name, :version => version, :api => api,
        :client_id => client_id, :client_secret => client_secret
    }
  end
  let(:settings) { GSimpleApi::Settings.new(params) }

  before { settings.load_api }

  describe "Instantiation process" do
    it "instantiates an authorizer" do
     instance = GSimpleApi::Manager.new(settings)
     instance.authorizer.should be_a GSimpleApi::Authorizer
    end

    context "with access token" do
      let(:code) { "1232222" }
      it "instantiates code" do
        GSimpleApi::Authorizer.any_instance.should_receive(:access_token=).with(code).once
        GSimpleApi::Manager.new(settings, code)
      end
    end

    context "without access token" do
      it "doesn't instantiate code" do
        GSimpleApi::Authorizer.any_instance.should_not_receive(:access_token=)
        GSimpleApi::Manager.new(settings)
      end
    end
  end

  describe "Methods" do
    subject { GSimpleApi::Manager.new(settings) }

    describe "#authorize_url" do
      let(:url) { "http://www.test.com" }

      it { should respond_to :authorize_url }

      it "updates authorization callback uri" do
        subject.authorize_url(url).should be_a String
      end
    end

    describe "#get_token" do
      let(:code) { "123456" }

      it { should respond_to :get_token }

      context "without refresh token" do
        it "calls #settings.code=" do
          subject.authorizer.authorization.stub(:fetch_access_token! => true)
          subject.authorizer.should_receive(:code=).once
          subject.get_token(code)
        end

        it "calls fetch_access_token!" do
          subject.authorizer.authorization.stub(:fetch_access_token! => true)
          subject.authorizer.authorization.should_receive(:fetch_access_token!).once
          subject.get_token(code)
        end
      end

      context "with refresh token" do
        it "calls #settings.code=" do
          subject.authorizer.authorization.stub(:fetch_access_token! => true)
          subject.authorizer.should_receive(:refresh_token=).once
          subject.get_token(code, true)
        end

        it "calls fetch_access_token!" do
          subject.authorizer.authorization.stub(:fetch_access_token! => true)
          subject.authorizer.authorization.should_receive(:fetch_access_token!).once
          subject.get_token(code, true)
        end
      end
    end

    describe "#execute" do
      let(:method) { "activities.list" }
      before do
        mock_execute = mock("Test", :data => "result")
        subject.stub(:split_method => ["activities", "list"])
        subject.stub(:chained_method_calls => "")
        subject.stub_chain(:settings, :discovered_api).and_return({})
        subject.stub_chain(:settings, :api_client, :execute).and_return(mock_execute)
      end

      it "calls #split_method once" do
        subject.should_receive(:split_method).with(method).once
        subject.execute(method)
      end

      it "calls #chained_method_calls once" do
        subject.should_receive(:chained_method_calls).
            with(subject.send(:split_method), subject.settings.discovered_api).once

        subject.execute(method)
      end

      it "returns call from #settings.api_client.execute" do
        subject.execute(method).should == "result"
      end
    end
  end

end