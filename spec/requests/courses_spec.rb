require 'rails_helper'

RSpec.describe CoursesController, type: :request do
  let(:user) { create :user }
  let(:course) { create :course }
  let(:valid_params) { {"title": "Mega Dance Party", "author_profile_id": user.author_profile.id } }

  describe 'POST #create' do
    context 'when valid params are passed' do

      it 'creates a new course' do
        expect { post '/courses', params: { course: valid_params } }.to change(Course, :count).by(1)
      end

      it 'returns a 201 status code' do
        post '/courses', params: { course: valid_params }
        expect(response.status).to eq(201)
      end

      it 'uses the CourseShowSerializer to format the response data' do
        post '/courses', params: { course: valid_params }
        expect(response.body).to include(valid_params[:title])
        expect(response.body).to include(user.email)
      end

      it 'returns the created course with correct attributes' do
        post '/courses', params: { course: valid_params }
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq(valid_params[:title])
        expect(json_response['author']['first_name']).to eq(user.first_name)
      end
    end

    context 'when invalid params are passed' do
      context 'when the author profile does not exist' do
        let(:invalid_author_params) { {"title": "Mega Dance Party", "author_profile_id": 10000} }
        it 'returns a 422 status code' do
          post '/courses', params: { course: invalid_author_params }
          expect(response.status).to eq(422)
        end

        it 'returns the errors' do
          post '/courses', params: { course: invalid_author_params }
          #TODO: fix this the params for this test
          expect(JSON.parse(response.body)).to eq({ 'errors' => ["Author profile must exist"],  "params" => {"author_profile_id"=>"10000", "title"=>"Mega Dance Party"}})
        end
      end

      context 'when the title does not exist' do
        let(:invalid_title_params) { {"title": "", "author_profile_id": user.author_profile.id} }
        it 'returns a 422 status code' do
          post '/courses', params: { course: invalid_title_params }
          expect(response.status).to eq(422)
        end

        it 'returns the errors' do
          post '/courses', params: { course: invalid_title_params }
          #TODO: fix this the params for this test
          expect(JSON.parse(response.body)).to eq("errors"=>["Title can't be blank"], "params"=>{"author_profile_id"=>"#{user.author_profile.id}", "title"=>""})
        end
      end
    end
  end

  describe 'GET #index' do
    let!(:courses) { create_list(:course, 3) }

    it 'returns a list of courses' do
      get '/courses'
      expect(JSON.parse(response.body).length).to eq(courses.length)
    end

    it 'returns a 200 status code' do
      get '/courses'
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    # it 'returns the requested course' do
    #   get "/courses/#{course.id}"
    #   expect(JSON.parse(response.body)).to eq(course.as_json)
    # end

    it 'uses the CourseShowSerializer to format the response data' do
      get "/courses/#{course.id}"
      expect(response.body).to include(course.title)
      expect(response.body).to include(course.author_profile.user.email)
    end

    it 'returns the course with correct attributes' do
      get "/courses/#{course.id}"
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq(course.title)
      expect(json_response['author']['first_name']).to eq(course.author_profile.user.first_name)
    end

    it 'returns a 200 status code' do
      get "/courses/#{course.id}"
      expect(response.status).to eq(200)
    end

    context "with students" do
      let(:course_with_students) { create :course, :with_students }
      it 'returns the course with students' do
        get "/courses/#{course_with_students.id}"
        json_response = JSON.parse(response.body)
        expect(json_response['students'].length).to eq(course_with_students.student_profiles.length)
      end

    end

    context "with learning path" do
      let!(:course_with_learning_path) { create :course, :with_learning_path }
      it 'returns the course with learning path' do
        get "/courses/#{course_with_learning_path.id}"
        json_response = JSON.parse(response.body)
        expect(json_response['learning_paths'].length).to eq(course_with_learning_path.learning_paths.length)
      end

    end
  end

  describe "PUT #update" do
    context "when valid parameters are provided" do
      let(:update_params) { { title: "New Course Name" } }
      it "updates the course record" do
        put "/courses/#{course.id}", params: { course: update_params }
        expect(course.reload.title).to eq(update_params[:title])
      end

      it "returns the updated course record" do
        put "/courses/#{course.id}", params: { course: update_params }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response["title"]).to eq(update_params[:title])
      end
    end

    context "when invalid parameters are provided" do
      let(:invalid_params) { { title: "" } }

      it "returns a 422 error response" do
        put "/courses/#{course.id}", params: { course: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when the specified id is not found" do
      it "returns a 404 error response" do
        put "/courses/#{course.id + 1000}", params: { course: { name: "New Course Name" } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end


  describe 'DELETE /courses/:id' do
    let!(:course_to_be_deleted) { create :course }
    context 'when the course exists' do
      it 'deletes the course' do
        expect {
          delete "/courses/#{course_to_be_deleted.id}"
        }.to change(Course, :count).by(-1)
      end

      it 'returns a success message' do
        delete "/courses/#{course_to_be_deleted.id}"
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({"message": 'Course deleted successfully'}.to_json)
      end
    end

    context 'when the course does not exist' do
      it 'returns a not found error' do
        delete '/courses/9999'
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to eq("Couldn't find Course with 'id'=9999")
      end
    end

    context 'when the course could not be deleted' do
      before do
        allow_any_instance_of(Course).to receive(:destroy).and_return(false)
      end

      it 'returns an unprocessable entity error' do
        #TODO: why could a course not be deleted?
        delete "/courses/#{course_to_be_deleted.id}"
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to match_json_expression({ error: 'Course could not be deleted' })
      end
    end
  end

  describe  'POST /courses/:id/enroll' do
    let!(:course_to_be_enrolled) { create :course }
    let(:student) { create :user }
    let(:enroll_params) { { student_profile_id: student.student_profile.id } }

    context 'when the course exists' do
      it 'enrolls the student in the course' do
        expect {
          post "/courses/#{course_to_be_enrolled.id}/enroll", params: enroll_params
        }.to change(course_to_be_enrolled.student_profiles, :count).by(1)
      end

      it 'returns a success message' do
        post "/courses/#{course_to_be_enrolled.id}/enroll", params: enroll_params
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(json_response["student_profile_id"]).to eq(enroll_params[:student_profile_id])
        expect(json_response["course_id"]).to eq(course_to_be_enrolled.id)
        expect(json_response["status"]).to eq("enrolled")
      end
    end

    context 'when the course does not exist' do
      it 'returns a not found error' do
        post '/courses/9999/enroll', params: { course: enroll_params }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to eq("Couldn't find Course with 'id'=9999")
      end
    end

    context 'when the course could not be enrolled' do
      # before do
      #   allow_any_instance_of(Course).to receive(:enroll).and_return(false)
      # end

      context 'when the student is already enrolled' do
        before do
          course_to_be_enrolled.enroll_student(student.student_profile)
        end

        it 'returns an unprocessable entity error' do
          post "/courses/#{course_to_be_enrolled.id}/enroll", params: enroll_params
          json_response = JSON.parse(response.body)
          pp json_response
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response["errors"].join).to eq("Student is already enrolled in this course")
        end
      end

      context 'when the student is the author of the course' do
        before do
          course_to_be_enrolled.update(author_profile_id: student.author_profile.id)
        end

        it 'returns an unprocessable entity error' do
          post "/courses/#{course_to_be_enrolled.id}/enroll", params: enroll_params
          json_response = JSON.parse(response.body)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response["errors"].join).to eq("Student is the author of this course")
        end
      end
    end
  end

  describe  'POST /courses/:id/complete' do
    let!(:course_to_be_completed) { create :course }
    let(:student) { create :user }
    let(:complete_params) { { student_profile_id: student.student_profile.id } }

    context 'when the course exists' do
      it 'completes the course for the student' do
        course_to_be_completed.enroll_student(student.student_profile)
        expect {
          post "/courses/#{course_to_be_completed.id}/complete", params: complete_params
        }.to change(course_to_be_completed.student_profiles, :count).by(0)
      end

      it 'returns a success message' do
        course_to_be_completed.enroll_student(student.student_profile)
        post "/courses/#{course_to_be_completed.id}/complete", params: complete_params
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response["message"]).to eq("Course completed successfully")
      end
    end

    context 'when the course does not exist' do
      it 'returns a not found error' do
        post '/courses/9999/complete', params: complete_params
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to eq("Couldn't find Course with 'id'=9999")
      end
    end

    context 'when the course could not be completed' do
      context 'when the student is not enrolled' do
        it 'returns an unprocessable entity error' do
          post "/courses/#{course_to_be_completed.id}/complete", params: complete_params
          json_response = JSON.parse(response.body)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response["errors"].join).to eq("Student is not enrolled in this course")
        end
      end

      context 'when the student is already completed the course' do
        before do
          course_to_be_completed.enroll_student(student.student_profile)
          course_to_be_completed.complete_course(student.student_profile)
        end

        it 'returns an unprocessable entity error' do
          post "/courses/#{
            course_to_be_completed.id}/complete", params: complete_params
          json_response = JSON.parse(response.body)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response["errors"].join).to eq("Student has already completed this course")
        end
      end
    end
  end
end
