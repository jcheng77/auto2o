class CommentsController < InheritedResources::Base


  





private


  def permitted_params
    params.require(:comment).permit(:content, :deal_id, :dealer_id, :shop_id)
  end

end
