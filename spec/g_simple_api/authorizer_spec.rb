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

describe GSimpleApi::Authorizer do
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

  describe "Methods" do
    before { settings.load_api }

    describe "#initialize" do
      it "calls #load_authorization" do
        GSimpleApi::Authorizer.any_instance.should_receive(:load_authorization).once
        GSimpleApi::Authorizer.new(settings)
      end
    end

    describe "#callback=" do
      let(:authorizer) { GSimpleApi::Authorizer.new(settings) }
      subject { authorizer }

      before { authorizer.settings.load_api }

      it { should respond_to(:callback=).with(1).argument }

      it "sets #redirect_uri value of authorization" do
        expect {
          authorizer.callback=("http://www.test.com")
        }.to change { authorizer.authorization.redirect_uri }
      end

      it "doesn't change anything if callback is nil" do
        expect {
          authorizer.callback=(nil)
        }.to_not change { authorizer.authorization.redirect_uri }
      end
    end

    describe "#code=" do
      let(:authorizer) { GSimpleApi::Authorizer.new(settings) }
      let(:code) { "123456" }
      subject { authorizer }

      before { authorizer.settings.load_api }

      it { should respond_to(:code=).with(1).argument }

      it "sets #code value of authorization" do
        expect {
          authorizer.code= code
        }.to change { authorizer.authorization.code }
      end

      it "doesn't change anything if code is nil" do
        expect {
          authorizer.code= nil
        }.to_not change { authorizer.authorization.code }
      end
    end

    describe "#set_access_token" do
      let(:authorizer) { GSimpleApi::Authorizer.new(settings) }
      let(:access_token) { "123456" }
      subject { authorizer }

      before { authorizer.settings.load_api }

      it { should respond_to(:access_token=).with(1).argument }

      it "sets #access_token value of authorization" do
        expect {
          authorizer.access_token= access_token
        }.to change { authorizer.authorization.access_token }
      end

      it "doesn't change anything if access_token is nil" do
        expect {
          authorizer.access_token= nil
        }.to_not change { authorizer.authorization.access_token }
      end
    end

    describe "#refresh_token=" do
      let(:authorizer) { GSimpleApi::Authorizer.new(settings) }
      let(:refresh_token) { "123456" }
      subject { authorizer }

      before { authorizer.settings.load_api }

      it { should respond_to(:refresh_token=).with(1).argument }

      it "sets #refresh_token value of authorization" do
        expect {
          authorizer.refresh_token=(refresh_token)
        }.to change { authorizer.authorization.refresh_token }
      end

      it "sets grant type to refresh_token" do
        expect {
          authorizer.refresh_token=(refresh_token)
        }.to change { authorizer.authorization.grant_type }.to("refresh_token")
      end
    end
  end
end