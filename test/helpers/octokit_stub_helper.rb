require 'webmock/minitest'


module OctokitStubHelper

  def accept_header
    'application/vnd.github.v3+json'
  end

  def encoding_header
    'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
  end

  def content_type
    'application/json'
  end

  def user_agent
    'Octokit Ruby Gem 4.18.0'
  end

  def octokit_update_org
  end

  def octokit_organization_membership_admin_in_org(org_name, username)
    text = File.open('test/sample jsons/org_member.json').read
    new_contents = text.gsub("anacapa-dev-class", "#{org_name}")
    new_contents = new_contents.gsub("anacapa-throwaway", "#{username}")
  end

  def octokit_organization_is_an_org(org_name)
    text = File.open('test/sample jsons/org.json').read
    new_contents = text.gsub("anacapa-dev-class", "#{org_name}")
  end

  def octokit_organization_does_not_exist
    File.open('test/sample jsons/no_org.json').read
  end

  def octokit_user_not_in_organization
    File.open('test/sample jsons/user_not_in_org.json').read
  end

  def octokit_invited_new_user_to_organization(org_name, username)
    text = File.open('test/sample jsons/invited_new_user_to_org.json').read
    text = text.gsub("org_name", "#{org_name}")
    text = text.gsub("username", "#{username}")
  end

  def octokit_get_emails(email)
    text = File.open('test/sample jsons/user_email.json').read
    text = text.gsub("user_email", "#{email}")
  end

  def stub_check_user_emails(email)
    stub_request(:get, "https://api.github.com/user/emails?per_page=100").
        with(  headers: {
            'Accept'=>accept_header,
            'Accept-Encoding'=>encoding_header,
            'Content-Type'=>content_type,
            'User-Agent'=>user_agent
        }).to_return(status: 200,
                     body: octokit_get_emails(email),
                     headers: {'Content-Type'=>content_type})
    stub_request(:get, "https://api.github.com/user/emails").
        with(  headers: {
            'Accept'=>accept_header,
            'Accept-Encoding'=>encoding_header,
            'Content-Type'=>content_type,
            'User-Agent'=>user_agent
        }).to_return(status: 200,
                     body: octokit_get_emails(email),
                     headers: {'Content-Type'=>content_type})
  end

  def stub_invite_user_to_org(github_id, org_name)
    stub_request(:put, "https://api.github.com/orgs/#{org_name}/memberships/#{github_id}").
      with(
        body: "{\"role\":\"member\"}",
        headers: {
        'Accept'=>accept_header,
        'Accept-Encoding'=>encoding_header,
        'Content-Type'=>content_type,
        'User-Agent'=>user_agent
        }).
        to_return(status: 200, body: octokit_invited_new_user_to_organization(org_name, github_id), headers: {})
  end

  def stub_find_user_in_org(student_github_id, org_name, isFound)
    code = 204
    body = ""
    unless isFound
      code = 404
      body = octokit_user_not_in_organization
    end

    stub_request(:get, "https://api.github.com/orgs/#{org_name}/members/#{student_github_id}").
      with(  headers: {
        'Accept'=>accept_header,
        'Accept-Encoding'=>encoding_header,
        'Content-Type'=>content_type,
        'User-Agent'=>user_agent
        }).
        to_return(status: code, body: body, headers: {})
  end

  def stub_updating_org_membership(org_name)
    stub_request(:patch, "https://api.github.com/user/memberships/orgs/#{org_name}").with(
      body: "{\"state\":\"active\"}",
      headers: {
      'Accept'=>accept_header,
      'Accept-Encoding'=>encoding_header,
      'Content-Type'=>content_type,
      'User-Agent'=>user_agent
      }).
    to_return(status: 200, body: "", headers: {})
  end

  def stub_organization_is_an_org(org_name)
    stub_request(:get, "https://api.github.com/orgs/#{org_name}").
    with(  headers: {
      'Accept'=>accept_header,
      'Accept-Encoding'=>encoding_header,
      'Content-Type'=>content_type,
      'User-Agent'=>user_agent
      }).
    to_return(status: 200,
              body: "#{octokit_organization_is_an_org(org_name)}",
              headers: {'Content-Type'=>content_type})

  end

  def stub_get_org_default_membership_permission(org_name)
      stub_request(:get, "https://api.github.com/orgs/#{org_name}").
      with(
      headers: {
            'Accept'=>'application/vnd.github.v3+json',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Octokit Ruby Gem 4.18.0'
      }).
    to_return(status: 200, body: "{\"default_membership_permission\":\"none\"}", headers: {})
  end

  def stub_organization_exists_but_not_admin_in_org(org_name)
    stub_request(:get, "https://api.github.com/user/memberships/orgs/#{org_name}").
      with(  headers: {
        'Accept'=>accept_header,
        'Accept-Encoding'=>encoding_header,
        'Content-Type'=>content_type,
        'User-Agent'=>user_agent
        }).
      to_return(status: 404,
                body: "#{octokit_organization_does_not_exist}",
                headers: {'Content-Type'=>content_type})
  end

  def stub_organization_does_not_exist(org_name)
    stub_request(:get, "https://api.github.com/orgs/#{org_name}").
    with(  headers: {
      'Accept'=>accept_header,
      'Accept-Encoding'=>encoding_header,
      'Content-Type'=>content_type,
      'User-Agent'=>user_agent
      }).
    to_return(status: 404,
              body: "#{octokit_organization_does_not_exist}",
              headers: {'Content-Type'=>content_type})
  end

  def stub_organization_membership_admin_in_org(org_name, username)
    stub_request(:get, "https://api.github.com/user/memberships/orgs/#{org_name}").
      with(  headers: {
        'Accept'=>accept_header,
        'Accept-Encoding'=>encoding_header,
        'Content-Type'=>content_type,
        'User-Agent'=>user_agent
        }).
      to_return(status: 200,
                body: "#{octokit_organization_membership_admin_in_org(org_name, username)}",
                headers: {'Content-Type'=>content_type})
  end

  def stub_org_repo_list_for_github_id(org_name)
    stub_request(:get, "https://api.github.com/orgs/" + org_name + "/repos").
      with(  headers: {
        'Accept'=>accept_header,
        'Accept-Encoding'=>encoding_header,
        'Content-Type'=>content_type,
        'User-Agent'=>user_agent
      }).
    to_return(status: 200, body: "", headers: {})
    stub_request(:get, "https://api.github.com/orgs/test-course-org-two/repos?per_page=100").
        with(  headers: {
            'Accept'=>accept_header,
            'Accept-Encoding'=>encoding_header,
            'Content-Type'=>content_type,
            'User-Agent'=>user_agent
        }).
        to_return(status: 200, body: "", headers: {})
  end

end