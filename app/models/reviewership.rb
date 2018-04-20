class Reviewership < ActiveRecord::Base
    belongs_to :reviewer, :class_name => 'User'
    belongs_to :user
    
    def create
        @user = User.find(params[:user_id])
        @reviewership = @user.reviewerships.build(:reviewer_id => current_user.id)
        respond_to do |format|
            if @reviewership.save
                format.html { redirect_to :back, notice: 'Review was succesfully submitted!' }
            else
                format.html { redirect_to :back, notice: 'Error. Review was not submitted!' }
            end
        end
    end
    
    def destroy
        @reviewership = @user.reviewerships.find(params[:id])
        @reviewership.destroy
        format.html { redirect_to :back, notice: 'Review was succesfully deleted!' }
    end
end
