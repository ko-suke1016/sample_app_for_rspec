require 'rails_helper'

RSpec.describe 'Tasks', type: :system do

    let(:task){ create(:task) }
    let(:user){ create(:user) }

    describe 'ログイン前' do
        context 'タスク新規作成ページにアクセス' do
            it '新規作成ページへのアクセスに失敗する' do
                visit new_task_path
                expect(current_path).to eq login_path
                expect(page).to have_content 'Login required'
            end
        end
        context 'ユーザーのタスク編集ページにアクセス' do
            it 'タスク編集ページへのアクセスに失敗する' do
                visit edit_task_path(task)
                expect(current_path).to eq login_path
                expect(page).to have_content 'Login required'
            end
        end
        context 'ユーザーのタスク詳細ページにアクセス' do
            it 'タスクの詳細情報が表示される' do
                visit task_path(task)
                expect(page).to have_content task.title
                expect(current_path).to eq task_path(task)
            end
        end
    end

    describe 'ログイン後' do

        before do
            login(user)
        end
        let!(:other_task){ create(:task) }

        describe 'タスクの新規登録' do
            context 'フォームの入力値が正常' do
                it 'タスクの新規登録が成功する' do
                    visit new_task_path
                    fill_in 'Title', with: 'first_task'
                    fill_in 'Content', with: 'first_content'
                    select 'todo', from: 'Status'
                    fill_in 'Deadline', with: task.deadline
                    click_button 'Create Task'
                    expect(current_path).to eq task_path(task.user_id)
                    expect(page).to have_content "Task was successfully created."
                end
            end
            context 'タイトルが未入力' do
                it 'タスクの新規登録が失敗する' do
                    visit new_task_path
                    fill_in 'Title', with: ''
                    fill_in 'Content', with: 'second_content'
                    select 'todo', from: 'Status'
                    fill_in 'Deadline', with: task.deadline
                    click_button 'Create Task'
                    expect(current_path).to eq tasks_path
                    expect(page).to have_content "Title can't be blank"
                end
            end

            context 'タイトルが重複している' do
                it 'タスクの新規登録が失敗する' do
                    visit new_task_path
                    fill_in 'Title', with: other_task.title
                    fill_in 'Content', with: 'therd_content'
                    select 'todo', from: 'Status'
                    fill_in 'Deadline', with: task.deadline
                    click_button 'Create Task'
                    expect(current_path).to eq tasks_path
                    expect(page).to have_content "Title has already been taken"
                end
            end
        end

        describe 'タスクの編集ができる' do

            let!(:task){ create(:task, user_id: user.id)}

            context 'フォームの入力値が正常' do
                it 'タスクの編集が成功する' do
                    visit edit_task_path(task)
                    fill_in 'Title', with: 'Update_title'
                    select :done, from: 'Status'
                    click_button 'Update Task'
                    expect(current_path).to eq task_path(task)
                    expect(page).to have_content "Task was successfully updated"
                end
            end

            context 'タイトルが未入力' do
                it 'タスクの編集が失敗する' do
                    visit tasks_path
                    click_on 'Edit'
                    fill_in 'Title', with: ""
                    click_button 'Update Task'
                    expect(current_path).to eq task_path(task)
                    expect(page).to have_content "Title can't be blank"
                end
            end
        end

        describe 'タスクの削除ができる' do

            let!(:task){create(:task, user_id: user.id)}

            context 'デストロイボタンをクリック' do
                it 'タスクの削除が成功する' do
                    visit tasks_path
                    click_on 'Destroy'
                    expect(page.accept_confirm).to eq "Are you sure?"
                    expect(current_path).to eq tasks_path
                    expect(page).to have_content 'Task was successfully destroyed'
                end
            end
        end
    end
end