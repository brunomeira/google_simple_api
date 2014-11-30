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

# @author  Bruno Meira <goesmeira@gmail.com> 
module GSimpleApi
    class Authorizer
        attr_reader :authorization
        attr_reader :settings

        def initialize(settings)
            @settings = settings
            @authorization = load_authorization
        end

        def callback=(callback)
            @authorization.redirect_uri = callback
        end

        def code=(code)
            @authorization.code = code
        end

        def access_token=(access_token)
            @authorization.access_token = access_token
        end

        def refresh_token=(refresh_token)
            @authorization.refresh_token = refresh_token
        end

        private
        def load_authorization
            auth = settings.api_client.authorization
            auth.client_id = settings.client_id
            auth.client_secret = settings.client_secret
            auth.scope = settings.scope.map { |elem| "https://www.googleapis.com/auth/#{elem}" }
            auth
        end
    end
end
