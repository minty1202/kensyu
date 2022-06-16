module Users
  class SearchesController < UsersController
    def search
      keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)
      puts '-----keyword------------------------------'
      puts keywords

      # @todos = keywords.map{|keyword| Todo.search_title(keyword).or(Todo.search_text(keyword)) }


      @todos = keywords.map do |keyword|
        Todo.where("title LIKE ? OR text LIKE ?" , "%#{keyword}%", "%#{keyword}%")
        # Todo.search_title(keyword).or(Todo.search_text(keyword))

        # @todos = Todo.where("title LIKE ? OR text LIKE ?" , "%#{keyword}%", "%#{keyword}%")
        # @todos = Todo.where("title LIKE ?" , "%#{keyword}%").or(Todo.where("text LIKE ?" , "%#{keyword}%"))
      end
      puts '---------@todos---------'
      puts @todos
      puts '---------ppp---------'
      p @todos
    end
  end
end
