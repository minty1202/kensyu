module Users
  class SearchesController < UsersController
    def search
      keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)

      @todos = keywords.map { |keyword| Todo.search_title(keyword).or(Todo.search_text(keyword)) }
      @todos = @todos.flatten.uniq
    end
  end
end
