require 'rails_helper'

RSpec.describe V1::CoursesController, type: :request do
  let(:user) { User.create(first_name: "Gisely", last_name: "Nunes", email: "giselynunes@dance.com")  }
  let(:author_profile) { AuthorProfile.create(user: user) }
  let(:course) {  Course.create(title: "Soccer in 1970's", author_profile_id: author_profile.id) }
  let(:valid_params) { {"title": "Mega Dance Party", "author_profile_id": author_profile.id} }
  describe 'POST #create' do
    context 'when valid params are passed' do

      it 'creates a new course' do
        expect { post '/v1/courses', params: { course: valid_params } }.to change(Course, :count).by(1)
      end

      it 'returns a 201 status code' do
        post '/v1/courses', params: { course: valid_params }
        expect(response.status).to eq(201)
      end

      it 'returns the created course' do
        post '/v1/courses', params: { course: valid_params }
        expect(JSON.parse(response.body)).to eq(Course.last.as_json)
      end
    end

    context 'when invalid params are passed' do
      context 'when the author profile does not exist' do
        let(:invalid_author_params) { {"title": "Mega Dance Party", "author_profile_id": 10000} }
        it 'returns a 422 status code' do
          post '/v1/courses', params: { course: invalid_author_params }
          expect(response.status).to eq(422)
        end

        it 'returns the errors' do
          post '/v1/courses', params: { course: invalid_author_params }
          #TODO: fix this the params for this test
          expect(JSON.parse(response.body)).to eq({ 'errors' => ["Author profile must exist"],  "params" => {"author_profile_id"=>"10000", "title"=>"Mega Dance Party"}})
        end
      end

      context 'when the title does not exist' do
        let(:invalid_title_params) { {"title": "", "author_profile_id": author_profile.id} }
        it 'returns a 422 status code' do
          post '/v1/courses', params: { course: invalid_title_params }
          expect(response.status).to eq(422)
        end

        it 'returns the errors' do
          post '/v1/courses', params: { course: invalid_title_params }
          #TODO: fix this the params for this test
          expect(JSON.parse(response.body)).to eq("errors"=>["Title can't be blank"], "params"=>{"author_profile_id"=>"#{author_profile.id}", "title"=>""})
        end
      end
    end
  end

  describe 'GET #index' do

    it 'returns a list of courses' do
      courses = []
      3.times do |i|
        courses << Course.create(title: "Brazilian Irish Cooking #{i+1}", author_profile_id: author_profile.id)
      end

      get '/v1/courses'
      expect(JSON.parse(response.body)).to eq(courses.as_json)
    end

    it 'returns a 200 status code' do
      get '/v1/courses'
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'returns the requested course' do
      get "/v1/courses/#{course.id}"
      expect(JSON.parse(response.body)).to eq(course.as_json)
    end

    it 'returns a 200 status code' do
      get "/v1/courses/#{course.id}"
      expect(response.status).to eq(200)
    end
  end

  describe "PUT #update" do
    context "when valid parameters are provided" do
      let(:update_params) { { title: "New Course Name" } }
      it "updates the course record" do
        put "/v1/courses/#{course.id}", params: { course: update_params }
        expect(course.reload.title).to eq(update_params[:title])
      end

      it "returns the updated course record" do
        put "/v1/courses/#{course.id}", params: { course: update_params }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["title"]).to eq(update_params[:title])
      end
    end

    context "when invalid parameters are provided" do
      let(:invalid_params) { { title: "" } }

      it "returns a 422 error response" do
        put "/v1/courses/#{course.id}", params: { course: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when the specified id is not found" do
      it "returns a 404 error response" do
        put "/v1/courses/#{course.id + 1}", params: { course: { name: "New Course Name" } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end


  describe 'DELETE /courses/:id' do
    #TODO: fix these delete tests
    context 'when the course exists' do
      let(:course_to_be_deleted) { Course.create(title: "Prince Andrew's guide to Dating", author_profile_id: author_profile.id) }
      Rails.logger.info "Courses before: #{Course.all.count}"
      pp "Courses before: #{Course.all.count}"

      it 'deletes the course' do
        expect {
          delete "/v1/courses/#{course_to_be_deleted.id}"
        }.to change(Course, :count).by(-1)
        # Rails.logger.debug "Courses before: #{Course.reload.all.count}"
        # pp "Courses before: #{Course.reload.all.count}"
      end

      it 'returns a success message' do
        delete "/v1/courses/#{course_to_be_deleted.id}"
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({"message": 'Course deleted successfully'}.to_json)
      end
    end

    context 'when the course does not exist' do
      it 'returns a not found error' do
        delete '/v1/courses/9999'
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq({ "error": "Couldn't find Course with 'id'=9999" }.to_json)
      end
    end

    context 'when the course could not be deleted' do
      before do
        allow_any_instance_of(Course).to receive(:destroy).and_return(false)
      end

      it 'returns an unprocessable entity error' do
        delete "/v1/courses/#{course_to_be_deleted.id}"
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to match_json_expression({ error: 'Course could not be deleted' })
      end
    end
  end

end
