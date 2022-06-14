require 'rails_helper'
require 'rake'

describe 'todo_notifier' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/todo_notifier'
    Rake::Task.define_task(:environment)
  end

  # spec内で同一タスクを2回以上実行しないのであれば不要
  # before(:each) do
  #   @rake[task].reenable
  # end

  describe 'get_todo_status' do
    let!(:todo) { create(:todo, limit_date: Time.current.tomorrow)}
    # モックを作る
    let(:notifier) { double("mock notifier", ping: 'Working as expected')}
    # newメソッドが呼べるようにし、作ったモックを返す
    before do
      allow(Slack::Notifier).to receive(:new).and_return(notifier)
    end
    it 'is Working as expected' do
      expect(Todo.notice_expired_todo).to eq ('Working as expected')
    end
  end
end
