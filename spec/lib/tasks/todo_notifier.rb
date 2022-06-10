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
    let(:task) { 'todo_notifier:get_todo_status' }

    it 'is success' do
      expect(@rake[task].invoke).to be_truthy
    end
  end
end
