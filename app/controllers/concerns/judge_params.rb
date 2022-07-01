module JudgeParams
  extend ActiveSupport::Concern

  # page=integerがページ数より大きいかどうか
  def bigger_page_number?
    (@set_todos.count / 8.to_f).ceil < params[:page].to_i
  end

  def judge_params
    # 1ページ目かつparamsの値が""でなければ return
    return if params[:page].blank? == true && params[:page] != ""

    # paramsの値が数字かどうか
    if !!(params[:page] =~ /^[0-9]+$/)
      no_page if bigger_page_number?
    else
      no_page
    end
  end
end
