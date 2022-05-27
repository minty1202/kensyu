module Search
  extend ActiveSupport::Concern

  class_methods do
    def lookfor(search, word, model, column)
      case search
      when "perfect_match"
        includes(model).where("#{column} LIKE ?", word.to_s)
      when "forward_match"
        includes(model).where("#{column} LIKE ?", word.to_s.concat('%'))
      when "backward_match"
        includes(model).where("#{column} LIKE ?", '%'.concat(word.to_s))
      when "partial_match"
        includes(model).where("#{column} LIKE ?", '%'.concat(word.to_s).concat('%'))
      else
        includes(model)
      end
    end
  end
end
