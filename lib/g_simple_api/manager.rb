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

# @author Bruno Meira
module GSimpleApi
    class Manager
        attr_reader :settings, :authorizer

        def initialize(settings, access_token = nil)
            @settings = settings
            @authorizer = GSimpleApi::Authorizer.new(settings)
            @authorizer.access_token = access_token if access_token
        end

        # Builds an URL that will be used by users to allow access to the apis.
        # @param callback_url [String] the URL that the user will be redirected back after approve or
        #  reject access to the api.
        # @return [String] the complete URL which the users need to be send to.
        def authorize_url(callback_url=nil)
            @authorizer.callback=(callback_url)
            @authorizer.authorization.authorization_uri.to_s
        end

        # Processes code param and returns a valid access_token.
        # @param code [String] the code returned from {#authorize_url} or
        #  a previous stored refresh_token if <tt>refresh_token</tt> was true.
        # @param refresh_token [Boolean] indicates if <tt>code</tt> is a refresh_token or a code from first access.
        # @return [Hash] with all required data for the api access.
        def get_token(code, refresh_token=false)
            if refresh_token
                authorizer.refresh_token=(code)
            else
                authorizer.code= code
            end

            authorizer.authorization.fetch_access_token!
        end

        # Executes call for the loaded api.
        # @param action [String] the resource that will be called.
        # @param parameters [Hash] the parameters associated with the action.
        # @return an object that contains the result of the call.
        def execute(action, parameters = {})
            methods = split_method(action)
            discovered_api = settings.discovered_api
            api_client = settings.api_client

            params = {
                :api_method => chained_method_calls(methods, discovered_api),
                :parameters => parameters
            }

            api_client.execute(params).data
        end

        private
        def chained_method_calls(methods, api)
            methods.inject(api) { |e, method| e.send(method.underscore) }
        end

        def split_method(method)
            method.split(".")
        end
    end
end
