require "test_helper"

class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  def setup
    @school = School.create!(name: 'Test School', subdomain: 'test', active: true)
    @user = @school.users.create!(email: 'user@test.edu', password: 'password', name: 'Test User', role: :user, active: true)
  end

  test "full authentication flow: sign in and use token" do
    # 1. Sign In
    # We must access via the correct subdomain
    host! "test.example.com"

    query = <<~GQL
      mutation {
        signIn(input: { email: "user@test.edu", password: "password" }) {
          token
          user { id email }
          errors
        }
      }
    GQL

    post "/graphql", params: { query: query }
    
    assert_response :success
    json = JSON.parse(response.body)
    data = json["data"]["signIn"]
    
    assert_empty data["errors"], "Sign in failed: #{data['errors']}"
    token = data["token"]
    assert_not_nil token, "Token should be present"
    user_id = data["user"]["id"]

    # 2. Update User (Authenticated)
    # Using the token we just received
    mutation = <<~GQL
      mutation {
        updateUser(input: { id: "#{user_id}", name: "Updated Name" }) {
          user { name }
          errors
        }
      }
    GQL

    post "/graphql", 
      params: { query: mutation },
      headers: { "Authorization" => "Bearer #{token}" }

    assert_response :success
    json = JSON.parse(response.body)
    
    # Check for GraphQL errors
    if json["errors"]
      flunk "GraphQL Error: #{json['errors']}"
    end

    result_data = json["data"]["updateUser"]
    assert_empty result_data["errors"], "Update user failed: #{result_data['errors']}"
    assert_equal "Updated Name", result_data["user"]["name"]
  end
  
  test "authentication fails with wrong credentials" do
    host! "test.example.com"
    
    query = <<~GQL
      mutation {
        signIn(input: { email: "user@test.edu", password: "wrong" }) {
          token
          errors
        }
      }
    GQL

    post "/graphql", params: { query: query }
    
    assert_response :success
    json = JSON.parse(response.body)
    data = json["data"]["signIn"]
    
    assert_nil data["token"]
    assert_includes data["errors"], "Invalid credentials"
  end
end
