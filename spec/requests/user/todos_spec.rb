require 'rails_helper'

RSpec.describe "Todos", type: :request do
  let!(:user) { create(:user) }
  let!(:tag) { create(:tag) }
  let!(:todo) { create(:todo) }
  let!(:todo_params) do
    { todo: { title: todo.title,
              text: todo.text,
              user_id: todo.user.id,
              limit_date: todo.limit_date,
              status: todo.status,
              name: tag.name } }
  end

  before do
    sign_in(todo.user)
  end

  describe "GET /todos/new #new" do
    it "return http success" do
      get new_users_todo_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST users/todos #create" do
    subject { post users_todos_path, params: todo_params }

    context 'valid params without images' do
      it 'create a new todo (without images)' do
        expect { subject }.to change(Todo, :count).by 1
      end

      it "redirect to users_mypage_url" do
        post users_todos_path(todo_params)
        expect(response).to redirect_to users_mypage_path
      end
    end

    context 'valid params with images' do
      before do
        todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      end

      it 'create a new todo (with images)' do
        expect do
          post users_todos_path(todo_params), params: todo_params.merge(images: todo.images)
        end.to change(Todo, :count).by 1
      end
    end

    context 'with invalid params' do
      let!(:todo_params) do
        { todo: { title: '',
                  text: '',
                  user_id: '',
                  name: '',
                  tag_ids: '' } }
      end

      it 'does not create a new todo' do
        expect { subject }.to_not change(Todo, :count)
      end
    end
  end

  describe "GET users/todos/:id/edit #edit" do
    it "return http success" do
      get edit_users_todo_path(todo)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /todos #update" do
    subject { patch users_todo_path(todo), params: todo_params }

    context 'with valid params' do
      it 'update the todo' do
        expect { subject }.to_not change(Todo, :count)
        expect(todo.reload.title).to eq 'MyString'
      end

      it "redirect to users_mypage_path" do
        subject

        expect(response).to redirect_to users_mypage_path
      end
    end

    context 'valid params with images' do
      before do
        todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      end

      it 'update the todo with images' do
        expect do
          patch users_todo_path(todo), params: todo_params.merge(images: todo.images)
        end.to_not change(Todo, :count)
      end

      it 'delete the images' do
        expect do
          patch users_todo_path(todo.id), params: todo_params.merge(images: todo.images, image_ids: [todo.images[0].id])
        end.to_not change(todo.images, :count)
      end
    end

    context 'with invalid params' do
      let!(:todo_params) do
        { todo: { title: '',
                  text: '',
                  user_id: '',
                  name: '' } }
      end

      it 'does not update the todo' do
        expect { subject }.to_not change(Todo, :count)
      end
    end
  end

  describe 'DELETE users/todos/#delete' do
    subject { delete users_todo_path(todo) }

    it 'delete the todo' do
      expect { subject }.to change(Todo, :count).by(-1)
    end

    it 'redirect to users_mypage_url' do
      subject

      expect(response).to redirect_to users_mypage_path
    end
  end
end
