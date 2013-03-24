#!/usr/bin/env ruby

require 'test/unit'
require 'rubygems'
require 'restclient'
require 'json'
require 'zd_client'
  
class TestZDClient < Test::Unit::TestCase
    
    def setup
        @client = ZDClient.new('om.bhatt@gmail.com', 'zendesk')
        @user = 'om.bhatt@gmail.com'
        @pass = 'zendesk'
    end
 
    def teardown
    end
    
    def test_create_user
        new_user = @client.create_user('John Smith', 'jon@smith.com')
        assert_not_nil(new_user)
        assert_equal("John Smith", new_user.name)
        assert_equal("jon@smith.com",new_user.email)
        begin
            new_user = client.create_user('John Smith', 'jon@smith.com')
            assert(false, "Able to create same user twice")
        rescue => e
            assert(true, "Expecting RuntimeException")
        end

        #clean up
        delete_url = "https://omtestapi.zendesk.com/api/v2/users/#{new_user.userid}.json"
        zd_user_delete_url = RestClient::Resource.new delete_url, @user, @pass
        zd_user_delete_url.delete
    end

    def test_create_resolve_ticket
        new_user = @client.create_user('James Smith', 'james@smith.com')
        assert_not_nil(new_user)
        assert_equal("James Smith", new_user.name)
        assert_equal("james@smith.com",new_user.email)
        new_ticket = @client.create_ticket(new_user, "Nothing works!", "Its your fault")
        assert_equal(new_user.userid, new_ticket.requester_id)
        @client.resolve_ticket(new_ticket, "I fixed it")

        # clean up
        tk_delete_url = "https://omtestapi.zendesk.com/api/v2/tickets/#{new_ticket.ticket_id}.json"
        zd_ticket_delete_url = RestClient::Resource.new tk_delete_url, @user, @pass
        zd_ticket_delete_url.delete

        delete_url = "https://omtestapi.zendesk.com/api/v2/users/#{new_user.userid}.json"
        zd_user_delete_url = RestClient::Resource.new delete_url, @user, @pass
        zd_user_delete_url.delete
    end

    def test_try_creating_empty_user
        begin
            new_user = @client.create_user('')
            assert(false, "Able to create user without name")
        rescue => e
            assert(true,"Expecting RuntimeException")
        end
    end

end
