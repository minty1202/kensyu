class TodoTag < ApplicationRecord
  belongs_to :todo
  belongs_to :tag

  validates :todo_id, presence: true
  validates :tag_id, presence: true

  # def hikmoduke
  #       # 古いタグの削除
  #   old_tags.each do |old|
  #     self.tags.delete Tag.find_by(name: old, user_id: self.user_id)
  #   end

  #   #新しいタグの保存
  #   new_tags.each do |new|
  #     new_todo_tag = Tag.find_or_create_by(name: new, user_id: self.user_id)
  #     self.tags << new_todo_tag #末尾に追加
  #   end
  # end
end
