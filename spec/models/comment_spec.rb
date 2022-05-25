require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) {build(:comment) }
  it 'textが必須であること'do
    comment.text = ' '
    expect(comment).to_not be_valid
  end

  it 'textが140文字以内であること'do
    comment.text = 'a' * 141
    expect(comment).to_not be_valid
  end

  it 'すべての値が正常ならコメントできること'do
    expect(comment).to be_valid
  end
end
