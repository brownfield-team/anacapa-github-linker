# encoding: utf-8
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'


module OctokitStubHelper

  def octokit_update_org
  end

  def octokit_organization_membership_admin_in_org(org_name, username)
    text = File.open('test/org_member.json').read
    new_contents = text.gsub("anacapa-dev-class", "#{org_name}")
    new_contents = new_contents.gsub("anacapa-throwaway", "#{username}")
  end

  def octokit_organization_is_an_org(org_name)
    text = File.open('test/org.json').read
    new_contents = text.gsub("anacapa-dev-class", "#{org_name}")
  end

  def stub_organization_is_an_org(org_name)
    stub_request(:get, "https://api.github.com/orgs/#{org_name}").
    with(  headers: {
      'Accept'=>'application/vnd.github.v3+json',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>'Basic YW5hY2FwYS10aHJvd2F3YXk6YjRiNDc0MGQ5OGQ0MGRmMWYzMjNhMTQ5NTM1NzA0Y2FmNTc2N2E2Yg==',
      'Content-Type'=>'application/json',
      'User-Agent'=>'Octokit Ruby Gem 4.8.0'
      }).
    to_return(status: 200, 
              body: "#{octokit_organization_is_an_org(org_name)}", 
              headers: {'Content-Type'=>'application/json'})

  end

  def stub_organization_membership_admin_in_org(org_name, username)
    stub_request(:get, "https://api.github.com/user/memberships/orgs/#{org_name}").
      with(  headers: {
        'Accept'=>'application/vnd.github.v3+json',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Basic YW5hY2FwYS10aHJvd2F3YXk6YjRiNDc0MGQ5OGQ0MGRmMWYzMjNhMTQ5NTM1NzA0Y2FmNTc2N2E2Yg==',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Octokit Ruby Gem 4.8.0'
        }).
      to_return(status: 200,
                body: "#{octokit_organization_membership_admin_in_org(org_name, username)}",
                headers: {'Content-Type'=>'application/json'})

  end

end

class ActiveSupport::TestCase
  include ActionDispatch::TestProcess
  include OctokitStubHelper

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
