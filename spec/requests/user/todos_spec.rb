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

    context '有効な値の場合（画像なし）' do
      it 'Todoを新しく作れること' do
        expect { subject }.to change(Todo, :count).by 1
      end

      it "ユーザー詳細ページにリダイレクトされること" do
        post users_todos_path(todo_params)
        expect(response).to redirect_to users_mypage_path
      end
    end

    context '有効な値の場合（画像あり）' do
      before do
        todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      end

      it 'Todoを新しく作れること' do
        expect do
          post users_todos_path(todo_params), params: todo_params.merge(images: todo.images)
        end.to change(Todo, :count).by 1
      end
    end

    context '無効な値の場合' do
      let!(:todo_params) do
        { todo: { title: '',
                  text: '',
                  user_id: '',
                  name: '',
                  tag_ids: '' } }
      end

      it 'Todoを新しく作れないこと' do
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

    context '有効な値の場合' do
      it 'Todoを更新できること' do
        expect { subject }.to_not change(Todo, :count)
        expect(todo.reload.title).to eq 'MyString'
      end

      it "ユーザー詳細ページにリダイレクトされること" do
        subject

        expect(response).to redirect_to users_mypage_path
      end
    end

    context '有効な値の場合（画像あり）' do
      before do
        todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
      end

      it '画像を更新できること' do
        expect do
          patch users_todo_path(todo), params: todo_params.merge(images: todo.images)
        end.to_not change(Todo, :count)
      end

      it '画像を削除できること' do
        expect do
          patch users_todo_path(todo.id), params: todo_params.merge(images: todo.images, image_ids: [todo.images[0].id])
        end.to_not change(todo.images, :count)
      end
    end

    context '無効な値の場合' do
      let!(:todo_params) do
        { todo: { title: '',
                  text: '',
                  user_id: '',
                  name: '' } }
      end

      it 'Todoを更新できないこと' do
        expect { subject }.to_not change(Todo, :count)
      end
    end
  end

  describe 'DELETE users/todos/#delete' do
    subject { delete users_todo_path(todo) }

    it 'Todoを削除できること' do
      expect { subject }.to change(Todo, :count).by(-1)
    end

    it 'ユーザー詳細ページにリダイレクトされること' do
      subject

      expect(response).to redirect_to users_mypage_path
    end
  end
end
