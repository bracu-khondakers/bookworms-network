class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :post_review, :delete_review]
  before_action :authorize_admin, only: [:index]
    
  helper_method :find_by_isbn

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
      @deal_exists = (Deal.exists?(buyer_id: current_user.id, seller_id: @user.id, confirmed: true) or Deal.exists?(buyer_id: @user.id, seller_id: current_user.id, confirmed: true))
      users = User.where(:id => @user.id)
      @hash = Gmaps4rails.build_markers(users) do |user, marker|
          if user.location              
              marker.lat user.location.latitude
              marker.lng user.location.longitude
              marker.picture ({
                  :url => view_context.image_path('marker.png'),
                  :width => 32,
                  :height => 32
                  })
          end
      end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    loc_params = {}
    loc_params[:address] = params[:user][:location]
    loc_params[:user_id] = current_user.id  
    if Location.exists?(user_id: current_user.id)
        Location.where(user_id: current_user.id)[0].update(loc_params)
    else
        Location.create!(loc_params)
    end
      
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
    
  def req
      @seller = Book.find(params[:id]).user_id
      deal_params = {}         
      deal_params[:book_id] = params[:id]
      deal_params[:seller_id] = @seller
      deal_params[:buyer_id] = current_user.id
      deal_params[:confirmed] = false
      @deal = Deal.new(deal_params)
      @deal.save
      
      noti_params = {}
      noti_params[:user_id] = @seller
      noti_params[:deal_id] = @deal.id
      @noti = Notification.new(noti_params)
      respond_to do |format|
          if @noti.save
              format.html { redirect_to :back, notice: 'Request sent!' }
          else
              format.html { redirect_to :back, notice: 'Error while sending request.' }
          end
      end
  end
    
  def accept
      deal = Deal.find(params[:id])
      respond_to do |format|
          deal.update(confirmed: true, date_of_transaction: Time.now)
          Notification.find_by(deal_id: deal.id).destroy!
          noti_params = {}
          noti_params[:user_id] = deal.buyer_id
          noti_params[:deal_id] = deal.id
          @noti = Notification.new(noti_params)
          @noti.save!
          @book = Book.find(deal.book_id)
          @book.availability = false
          @book.save!
          format.html { redirect_to :back, notice: 'Your contact information has been transferred to the user!' }
      end
  end
    
  def reject
      deal = Deal.find(params[:id])
      respond_to do |format|
          deal.destroy!
          Notification.find_by(deal_id: deal.id).destroy!
          format.html { redirect_to :back, notice: 'You have declined the request!' }
      end
  end
    
  def post_review
      @reviewership = @user.reviewerships.build(:reviewer_id => current_user.id, :review => params[:review], :rating => params[:rating],:approved => false)
      respond_to do |format|
          if @reviewership.save  
              format.html { redirect_to :back, notice: 'Your review has been queued up for admin moderation. It will be posted as soon as it is approved.' }
          end
      end
  end
    
  def delete_review
      @reviewership = current_user.inverse_reviewerships.find(params[:id])
      @reviewership.destroy
      respond_to do |format|  
          format.html { redirect_to :back, notice: 'Your review successfully deleted.' }
      end
  end
    
  def find_by_isbn isbn
      ISBN.find_by_isbn isbn
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      @user_books = @user.books.paginate(:page => params[:page], :per_page => 3)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
        params.require(:user).permit(:name, :password, :birth_date, :about_me, :address, :image, :remove_image)
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
