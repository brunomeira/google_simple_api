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

require "google/api_client"

require "google_simple_api/settings"
require "google_simple_api/authorizer"
require "google_simple_api/manager"
require "google_simple_api/version"

# @author Bruno Meira <goesmeira@gmail.com>
module GoogleSimpleApi
    class << self
        attr_reader :settings
    end

    # Prepares the api for initial use. It assigns variables and load dependencies.
    # @yield [settings] Gets an instance of {GoogleSimpleApi::Settings} and assigns value to its attributes.
    # @return [void]
    def self.setup
        yield(settings)
        settings.load_api
    end

    # Returns an instance of #<tt>GoogleSimpleApi::Manager</tt>.
    # @param access_token [String] a valid token.
    # @return [GoogleSimpleApi::Manager] the object that handles authorization and api calls.
    def self.process(access_token = nil)
        GoogleSimpleApi::Manager.new(settings, access_token)
    end

    private
    def self.settings
        @settings ||= GoogleSimpleApi::Settings.new
    end
end
