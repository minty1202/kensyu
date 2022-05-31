require 'rails_helper'

RSpec.describe "Todos", type: :request do
  let!(:user) { create(:user) }
  let!(:tag) { create(:tag) }


  describe "GET /todos/new #new" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      it "return http success" do
        get new_users_todo_path(user)
        expect(response).to have_http_status(:success)
      end
    end
    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get new_users_todo_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST users/todos #create" do
    context 'ログインしている場合' do
      before do
        sign_in(user)
      end
      context '登録が失敗する場合' do
        it '無効な値だと登録されないこと' do
          expect {
            post users_todos_path, params:{todo: {title: '',
                                          text: '',
                                          user_id: '',
                                          name: ''}}
            }.to_not change(Todo, :count)
        end
      end
      context '登録が成功する場合' do
        let(:todo_params) { { todo: { title: 'test',
                                  text: 'hogehogehoge',
                                  user_id: 1,
                                  name: tag.name} } }
        it '登録されること(画像なし)' do
        expect{
          post users_todos_path, params: todo_params
        }.to change(Todo, :count).by 1
        end

        it "ユーザー詳細ページにリダイレクトされること" do
          post users_todos_path(todo_params)
          expect(response).to redirect_to users_mypage_path
          expect(flash[:success]).to be_truthy
        end

        context '画像投稿がある場合' do
          let!(:todo) { create(:todo) }
          before do
            todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
          end
          it '登録されること(画像あり)' do
            expect{
              post users_todos_path(todo), params: { todo: {
                                                        title: todo.title,
                                                        text: todo.text,
                                                        user_id: todo.user.id ,
                                                        images: todo.images,
                                                        name: tag.name,
                                                    } }
              }.to change(Todo, :count).by 1
          end
        end
      end
    end
    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        post users_todos_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET users/todos/:id/edit #edit" do
    let!(:todo) { create(:todo) }
    context 'ログインしている場合' do
      before do
        sign_in(todo.user)
      end
      it "return http success" do
        get edit_users_todo_path(todo)
        expect(response).to have_http_status(:success)
      end
    end
    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        get edit_users_todo_path(todo)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH /todos #update" do
    let!(:todo) { create(:todo) }
    let!(:tag) { create(:tag) }

    context 'ログインしている場合' do
      before do
        sign_in(todo.user)
      end
      context '更新が失敗する場合' do
        it '無効な値だと更新されないこと' do
          expect {
            patch users_todo_path(todo), params:{todo: {title: '',
                                          text: '',
                                          user_id: '',
                                          name: ''}}
            }.to_not change(Todo, :count)
        end
      end
      context '更新が成功する場合' do
        let(:todo_params) { { todo: { title: 'test',
                                  text: 'hogehogehoge',
                                  user_id: todo.user.id,
                                  name: tag.name}} }
        it '更新されること' do
          expect{
            patch users_todo_path(todo), params: todo_params
          }.to_not change(Todo, :count)
          expect(todo.reload.title).to eq 'test'
        end

        it "ユーザー詳細ページにリダイレクトされること" do
          patch users_todo_path(todo), params: todo_params
          expect(response).to redirect_to users_mypage_path
          expect(flash[:success]).to be_truthy
        end

        context '画像投稿がある場合' do
          before do
            todo.images.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
          end
          it '画像投稿追加して更新できること' do
            expect{
              patch users_todo_path(todo), params: { todo: {
                                                        title: todo.title,
                                                        text: todo.text,
                                                        user_id: todo.user.id ,
                                                        images: todo.images,
                                                        name: tag.name
                                                    } }
            }.to_not change(Todo, :count)
          end

          it '画像を削除して更新できること' do
            expect{ patch users_todo_path(todo.id), params: {todo: {
                                                              title: todo.title,
                                                              text: todo.text,
                                                              image_ids: [todo.images[0].id],
                                                              name: tag.name
                                                            }}
            }.to change { todo.images.count }.from(1).to(0)
          end
        end
      end
    end
    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされること" do
        patch users_todo_path(todo)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE users/todos/#delete' do
    let!(:todo) { create(:todo) }
    context 'ログインしている場合'do
      before do
        sign_in(todo.user)
      end

      it "編集ページに移動すること" do
        get edit_users_todo_path(todo)
        expect(response).to have_http_status(:success)
      end

      # context '削除が失敗する場合' do
      # end

      context '削除が成功する場合' do
        it '削除されること' do
          expect{
            delete users_todo_path(todo)
          }.to change(Todo, :count).by(-1)
        end
        it 'ユーザー詳細ページにリダイレクトされること' do
          delete users_todo_path(todo)
          expect(response).to redirect_to users_mypage_path
          expect(flash[:success]).to be_truthy
        end
      end
    end

    context 'ログインしていない場合'do
      it "ログインページにリダイレクトされること" do
        delete users_todo_path(todo)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
