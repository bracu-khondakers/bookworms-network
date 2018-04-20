class DonationsController < ApplicationController
    before_action :authenticate_user!, only: [:index, :show, :edit, :update, :destroy, :accept]
    before_action :authorize_admin, only: [:accept]
    before_action :set_donation, only: [:accept]
    
    def index
        @donations = Donation.all
    end
    
    def create
        book_id = User.find(current_user.id).books.where(isbn: donation_params[:isbn].strip.delete('-')).pluck(:id)[0]
        
        if book_id
            if Donation.exists?(book_id: book_id)
                respond_to do |format|
                    format.html { redirect_to :back, notice: 'Looks like the book has already been donated.' }
                end
            else
                @donation = Donation.new({user_id: current_user.id, book_id: book_id, accepted: false})
                respond_to do |format|
                    if @donation.save
                        format.html { redirect_to :back, notice: 'Donation was successfully submitted. It will be added to the donations list once the admin accepts it.' }
                    end
                end                
            end
        else
            respond_to do |format|
                format.html { redirect_to :back, notice: 'Sorry it doesn\'t seem like you own that book' }
            end
        end
    end

    def accept
        respond_to do |format|
            if @donation.accepted
                @donation.update({:accepted => false})
                Book.update(@donation.book_id, :availability=> true)
            else
                @donation.update({:accepted => true})
                Book.update(@donation.book_id, :availability=> false)
            end
            format.html { redirect_to :back, notice: 'Acceptance toggled!' }
        end
    end

    private
        def donation_params
            params.require(:book).permit(:isbn)
        end
    
        def set_donation
            @donation = Donation.find(params[:id])
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