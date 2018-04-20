class BookReviewsController < ApplicationController
    before_action :authenticate_user!, only: [:index, :show, :edit, :update, :destroy, :approve]
    before_action :authorize_admin, only: [:index, :approve]
    before_action :set_book_review, only: [:approve]
    
    def index
        @book_reviews = BookReview.all
    end

    def approve
        respond_to do |format|
            if @book_review.approved
                @book_review.update({:approved => false})
            else
                @book_review.update({:approved => true})                
            end
            format.html { redirect_to :back, notice: 'Approval toggled!' }
        end
    end

    private
        def book_review_params
            params.require(:book_review).permit(:user_id, :book_id, :rating, :review)
        end
    
        def set_book_review
            @book_review = BookReview.find(params[:id])
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