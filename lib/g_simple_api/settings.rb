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

# @author Bruno Meira <goesmeira@gmail.com> 
module GSimpleApi
  class Settings

    attr_accessor :api, :api_client, :client_id, :client_secret,
                  :discovered_api, :name, :version, :scope, :api_version

    def initialize(options = {})
      @api = options[:api]
      @client_id = options[:client_id]
      @client_secret = options[:client_secret]
      @name = options[:name]
      @api_version = options[:api_version]
      @version = options[:version]
      @scope = [].push(options[:scope]).flatten
    end

    def load_api
      @api_client = load_api_client
      @discovered_api = discover_api if @api_client
    end

    def scope=(value)
      @scope = [].push(value).flatten
    end

    private
    def load_api_client
      params = {
          :application_name => @name,
          :application_version => @version
      }

      Google::APIClient.new(params)
    end

    def discover_api
      @api_client.discovered_api(@api, @api_version || "v1")
    end
  end
end
