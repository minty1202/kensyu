require 'rails_helper'
require 'rake'

describe 'change_status' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    # Rake.application.rake_require('change_expired', [Rails.root.join('lib', 'tasks', 'change_status')])
    Rake.application.rake_require 'tasks/change_status'
    Rake::Task.define_task(:environment)
  end

  # spec内で同一タスクを2回以上実行しないのであれば不要
  # before(:each) do
  #   @rake[task].reenable
  # end

  describe 'change_expired' do
    let(:task) { 'change_status:change_expired' }

    it 'is success' do
      expect(@rake[task].invoke).to be_truthy
    end
  end
end
