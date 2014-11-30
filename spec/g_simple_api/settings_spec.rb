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

describe GSimpleApi::Settings do
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

  describe "Methods" do
    describe "#initialize" do
      it "assigns values to #name, #version, #api, #client_id and #client_secret" do
        settings = GSimpleApi::Settings.new(params)

        settings.name.should == name
        settings.version.should == version
        settings.api.should == api
        settings.client_id.should == client_id
        settings.client_secret.should == client_secret
      end
    end

    describe "#load_api" do
      it "calls #load_api_client" do
        GSimpleApi::Settings.any_instance.should_receive(:load_api_client).once
        settings = GSimpleApi::Settings.new(params)
        settings.load_api
      end

      it "calls #discover_api" do
        GSimpleApi::Settings.any_instance.should_receive(:discover_api).once
        settings = GSimpleApi::Settings.new(params)
        settings.load_api
      end
    end
  end
end