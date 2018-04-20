class ReviewershipsController < ApplicationController
    before_action :authenticate_user!, only: [:index, :show, :edit, :update, :destroy, :approve]
    before_action :authorize_admin, only: [:index, :approve]
    before_action :set_reviewership, only: [:approve]
    
    def index
        @reviewerships = Reviewership.all
    end

    def approve
        respond_to do |format|
            if @reviewership.approved
                @reviewership.update({:approved => false})
            else
                @reviewership.update({:approved => true})                
            end
            format.html { redirect_to :back, notice: 'Approval toggled!' }
        end
    end

    private
        def reviewership_params
            params.require(:reviewership).permit(:user_id, :reviewer_id, :rating, :review)
        end
    
        def set_reviewership
            @reviewership = Reviewership.find(params[:id])
        end
        
        def authorize_admin
            if current_user and current_user.privilege and current_user.privilege.admin
                
            else
                respond_to do |format|
                    format.html { redirect_to root_path, notice: 'Sorry, you need administrator privileges to perform that action' }
                end
            end
        end    
end