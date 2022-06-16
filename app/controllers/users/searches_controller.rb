module Users
  class SearchesController < UsersController
    def search
      keywords = params[:keyword].split(/\s/)
      @todos = keywords.map { |keyword| Todo.search_title(keyword).or(Todo.search_text(keyword)) }.flatten.uniq
      @todos = @todos.sort { |a, b| a[:limit_date] <=> b[:limit_date] }
    end
  end
end
