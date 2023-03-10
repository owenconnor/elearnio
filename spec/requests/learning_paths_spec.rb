require 'rails_helper'

RSpec.describe "LearningPaths", type: :request do
  describe 'GET #index' do
    let!(:learning_paths) { create_list(:learning_path, 3) }

    it 'returns a list of learning_paths' do
      get '/v1/learning_paths'
      expect(JSON.parse(response.body).length).to eq(learning_paths.length)
    end

    it 'returns a 200 status code' do
      get '/v1/learning_paths'
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    let!(:learning_path) { create(:learning_path) }
    let!(:learning_path_with_courses) { create(:learning_path, :with_courses) }

    it 'uses the LearningPathShowSerializer to format the response data' do
      get "/v1/learning_paths/#{learning_path.id}"
      expect(response.body).to include(learning_path.title)
    end

    it 'returns the learning_path with correct attributes' do
      get "/v1/learning_paths/#{learning_path.id}"
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq(learning_path.title)
    end



    it 'returns a 200 status code' do
      get "/v1/learning_paths/#{learning_path.id}"
      expect(response.status).to eq(200)
    end

    context "with courses" do
      it 'returns the learning_path with courses' do
        get "/v1/learning_paths/#{learning_path_with_courses.id}"
        json_response = JSON.parse(response.body)
        expect(json_response['courses'].length).to eq(learning_path_with_courses.courses.length)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { title: 'New Learning Path' } }
    let(:invalid_attributes) { { title: '' } }

    context 'with valid attributes' do
      it 'creates a new learning_path' do
        expect {
          post '/v1/learning_paths', params: { learning_path: valid_attributes }
        }.to change(LearningPath, :count).by(1)
      end

      it 'returns a 201 status code' do
        post '/v1/learning_paths', params: { learning_path: valid_attributes }
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new learning_path' do
        expect {
          post '/v1/learning_paths', params: { learning_path: invalid_attributes }
        }.to change(LearningPath, :count).by(0)
      end

      it 'returns a 422 status code' do
        post '/v1/learning_paths', params: { learning_path: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    let!(:learning_path) { create(:learning_path) }
    let(:valid_attributes) { { title: 'Updated Learning Path' } }
    let(:invalid_attributes) { { title: '' } }

    context 'with valid attributes' do
      it 'updates the learning_path' do
        put "/v1/learning_paths/#{learning_path.id}", params: { learning_path: valid_attributes }
        learning_path.reload
        expect(learning_path.title).to eq('Updated Learning Path')
      end

      it 'returns a 200 status code' do
        put "/v1/learning_paths/#{learning_path.id}", params: { learning_path: valid_attributes }
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the learning_path' do
        put "/v1/learning_paths/#{learning_path.id}", params: { learning_path: invalid_attributes }
        learning_path.reload
        expect(learning_path.title).to_not eq('')
      end

      it 'returns a 422 status code' do
        put "/v1/learning_paths/#{learning_path.id}", params: { learning_path: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end
end
