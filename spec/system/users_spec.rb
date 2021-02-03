require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user_a){ build(:user) }
  let(:user){ create(:user) }
  let(:other_user){ create(:user) }
  let(:task){ create(:task)}

  describe 'ログイン前' do
    describe 'ユーザー新規登録'
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit sign_up_path
          fill_in "Email", with: user_a.email
          fill_in "Password", with: user_a.password
          fill_in "Password confirmation", with: user_a.password_confirmation
          click_button 'SignUp'
          expect(current_path).to eq login_path
          expect(page).to have_content 'User was successfully created.'
        end
      end

      context 'メールアドレレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: ''
          fill_in 'Password', with: user_a.password
          fill_in 'Password confirmation', with: user_a.password_confirmation
          click_button 'SignUp'
          expect(current_path).to eq users_path
          expect(page).to have_content "Email can't be blank"
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)
          expect(current_path).to eq login_path
          expect(page).to have_content "Login required"
        end
      end
    end

  describe 'ログイン後' do
    before do
      login(user)
    end
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_path(user)
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          fill_in 'Password confirmation', with: user.password
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "User was successfully updated."
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: ""
          fill_in 'Password', with: 'example'
          fill_in 'Password confirmation', with: 'example'
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: other_user.email
          fill_in 'Password', with: 'example'
          fill_in 'Password confirmation', with: 'example'
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email has already been taken"
        end
      end

      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスに失敗する' do
          visit edit_user_path(other_user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Forbidden access"
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          visit new_task_path
          fill_in 'Title', with: task.title
          fill_in 'Content', with: task.content
          select task.status, from: 'Status'
          fill_in 'Deadline', with: task.deadline
          click_button 'Create Task'
          expect(page).to have_content "Task was successfully created."
        end
      end
    end
  end
end
