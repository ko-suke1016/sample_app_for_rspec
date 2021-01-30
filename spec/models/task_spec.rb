require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'title,content,status,deadlineがあれば有効な状態であること' do
    expect(FactoryBot.build(:task)).to be_valid
  end

  it 'タイトルがなければ無効な状態であること' do
    task = FactoryBot.build(:task, title: nil)
    task.valid?
    expect(task.errors[:title]).to include("can't be blank")
  end

  it '重複したタイトルなら無効な状態であること' do
    FactoryBot.create(:task)
    task = FactoryBot.build(:task)
    task.valid?
    expect(task.errors[:title]).to include()
  end

  it 'statusがなければ無効な状態であること' do
    task = FactoryBot.build(:task, status: nil)
    task.valid?
    expect(task.errors[:status]).to include("can't be blank")
  end

  it '他のタイトルであれば有効な状態であること' do
    FactoryBot.create(:task)
    task = FactoryBot.build(:task)
    task.valid?
    expect(FactoryBot.build(:task)).to be_valid
  end
end
