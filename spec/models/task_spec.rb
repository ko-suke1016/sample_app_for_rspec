require 'rails_helper'

RSpec.describe 'validate', type: :model do
  it 'title,content,status,deadlineがあれば有効な状態であること' do
    expect(FactoryBot.build(:task)).to be_valid
  end

  it 'タイトルがなければ無効な状態であること' do
    task_without_title = FactoryBot.build(:task, title: "")
    expect(task_without_title).to be_invalid
    expect(task_without_title.errors[:title]).to eq ["can't be blank"]
  end

  it '重複したタイトルなら無効な状態であること' do
    task = FactoryBot.create(:task)
    task_with_duplicated_title = FactoryBot.build(:task, title: task.title)
    expect(task_with_duplicated_title).to be_invalid
    expect(task_with_duplicated_title.errors[:title]).to eq ["has already been taken"]
  end

  it 'statusがなければ無効な状態であること' do
    task_without_status = FactoryBot.build(:task, status: nil)
    expect(task_without_status).to be_invalid
    expect(task_without_status.errors[:status]).to eq ["can't be blank"]
  end

  it '他のタイトルであれば有効な状態であること' do
    FactoryBot.create(:task)
    task_with_another_title = FactoryBot.build(:task)
    expect(task_with_another_title).to be_valid
    expect(task_with_another_title.errors).to be_empty
  end
end
