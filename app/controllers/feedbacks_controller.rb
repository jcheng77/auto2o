class FeedbacksController < InheritedResources::Base

  private

  def permitted_params
    params.require(:feedback).permit(:content, :user_id)
  end

end
