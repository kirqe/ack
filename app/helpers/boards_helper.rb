module BoardsHelper
  def is_hg?(board) 
    key = (controller_name == "boards") ? :id : :board_id
    params[key] == board.slug
  end
end
