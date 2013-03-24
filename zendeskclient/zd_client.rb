
#!/usr/bin/env ruby

require 'rubygems'
require 'rest_client'
require 'json'

class ZDClient

    attr_accessor :user
    
    def initialize(user, password)
        @user = user
        @password = password
        @zd_user_create_url = RestClient::Resource.new 'https://omtestapi.zendesk.com/api/v2/users.json', @user, @password
        @zd_ticket_create_url = RestClient::Resource.new 'https://omtestapi.zendesk.com/api/v2/tickets.json', @user, @password
    end

    # simple user creation for test purpose, would take a hash in as parameter in production for all settable attributes
    def create_user(name, email = '')
        begin
            user_details = { :name => "#{name}", :email => "#{email}" }
            user = { :user => user_details }
            response = @zd_user_create_url.post user.to_json, :content_type => 'application/json'
            return User.new(response)
        rescue => e
            error_parsed = JSON.parse(e.response)
            desc = error_parsed["details"].values[0][0]["description"]
            raise desc
        end
    end

    # simple ticket creation for test purpose, would take a hash in as parameter in production for all settable attributes
    def create_ticket(requester, subject, comment)
        begin
            ticket_details = { :subject => "#{subject}", :description => "#{comment}", :requester_id => "#{requester.userid}" }
            ticket =  { :ticket => ticket_details }
            response = @zd_ticket_create_url.post ticket.to_json,  :content_type => 'application/json'
            return Ticket.new(response)
        rescue => e
            error_parsed = JSON.parse(e.response)
            desc =  error_parsed["details"].values[0][0]["description"]
            raise desc
        end
    end

    def resolve_ticket(ticket, comment)
        begin
            resolve_url = "https://omtestapi.zendesk.com/api/v2/tickets/#{ticket.ticket_id}.json"
            zd_ticket_resolve_url = RestClient::Resource.new resolve_url, @user, @password
            ticket_details = { :status => "solved", :comment => "#{comment}"}
            ticket =  { :ticket => ticket_details }
            response = zd_ticket_resolve_url.put ticket.to_json,  :content_type => 'application/json'
            return Ticket.new(response)
        rescue => e
            error_parsed = JSON.parse(e.response)
            error_parsed
        end
    end
end

class User
    attr_accessor :userid
    attr_accessor :name
    attr_accessor :email

    def initialize(json_response)
        parsed = JSON.parse(json_response)
        @userid = parsed["user"]["id"]
        @name = parsed["user"]["name"]
        @email = parsed["user"]["email"]
    end

end

class Ticket
    attr_accessor :requester_id
    attr_accessor :ticket_id
    attr_accessor :subject
    attr_accessor :comment

    def initialize(json_response)
        parsed = JSON.parse(json_response)
        @ticket_id = parsed["ticket"]["id"]
        @requester_id = parsed["ticket"]["requester_id"]
        @subject = parsed["ticket"]["subject"]
        @comment = parsed["ticket"]["comment"]
    end
end
