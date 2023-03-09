require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }

  describe 'GET /v1/users' do
    before { get '/v1/users' }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns all users' do
      expect(JSON.parse(response.body).size).to eq(10)
    end
  end

  describe 'GET /v1/users/:id' do
    before { get "/v1/users/#{user_id}" }

    context 'when the record exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the user' do
        expect(JSON.parse(response.body)['id']).to eq(user_id)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) { 9999 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  describe 'POST /v1/users' do
    let(:valid_attributes) {{ user: { first_name: 'Prince', last_name:"Andrew", email: 'andrew@frogmore.com' }}}

    context 'when the request is valid' do
      before { post '/v1/users', params: valid_attributes }

      it 'creates a user' do
        expect(JSON.parse(response.body)['first_name']).to eq('Prince')
        expect(JSON.parse(response.body)['email']).to eq('andrew@frogmore.com')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/v1/users', params: { user: { first_name: '', last_name:"Andrew", email: 'andrew@frogmore.com' }}}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/First name can't be blank/)
      end
    end
  end

  describe 'PUT /v1/users/:id' do
    #TODO: action is being refactored so this will be too
    let(:valid_attributes) { { last_name: 'Deedpoll' } }

    context 'when the record exists' do
      before { put "/v1/users/#{user_id}", params: valid_attributes }

      it 'updates the user' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/users/:id' do
    before { delete "/v1/users/#{user_id}" }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns a deleted successfully message' do
      expect(response.body).to match(/User deleted successfully/)
    end

  end
end
