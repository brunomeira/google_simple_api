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

require "spec_helper"

describe GoogleSimpleApi do
  let(:name) { "test" }
  let(:version) { "1.0.0" }
  let(:api) { "plus" }
  let(:api_version) { "v1" }
  let(:client_id) { "123152412412" }
  let(:client_secret) { "sad3121232" }
  let(:scope) { "plus.me" }

  let(:setup_call) do
    GoogleSimpleApi.setup do |config|
      config.name = name
      config.version = version
      config.api = api
      config.api_version = api_version
      config.client_id = client_id
      config.client_secret = client_secret
      config.scope = scope
    end
  end

  describe "Methods" do
    describe ".setup" do
      it { GoogleSimpleApi.should respond_to :setup }

      it "creates a valid instance of GoogleSimpleApi::Setting" do
        setup_call
        GoogleSimpleApi.settings.class.should == GoogleSimpleApi::Settings
        GoogleSimpleApi.settings.name.should == name
        GoogleSimpleApi.settings.version.should == version
        GoogleSimpleApi.settings.api.should == api
        GoogleSimpleApi.settings.api_version.should == api_version
        GoogleSimpleApi.settings.client_id.should == client_id
        GoogleSimpleApi.settings.client_secret.should == client_secret
      end

      it "loads api" do
        GoogleSimpleApi.settings.should_receive(:load_api).once
        setup_call
      end

    end

    describe ".process" do
      it { GoogleSimpleApi.should respond_to :process }
      it { GoogleSimpleApi.process.should be_a GoogleSimpleApi::Manager }
    end
  end


  describe "full flow" do
    let(:client_id) { "765210565694-ptflkrme0ef5rjjai8agg36h5mbj0fdv.apps.googleusercontent.com" }
    let(:client_secret) { "2negC6yH_qkdLy_SX2J5VCNt" }
    let(:authorization_url) { "http://localhost:3000/my/access_tokens/google_callback" }

    it "creates an authorization URL" do
      setup_call
      GoogleSimpleApi.process.authorize_url(authorization_url).should be_a String
    end
  end

end
