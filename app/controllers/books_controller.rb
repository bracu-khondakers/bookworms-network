class BooksController < ApplicationController
  include HTTParty
  before_action :authenticate_user!, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_book, only: [:show, :edit, :update, :destroy, :post_review]
  $api_key = '6MBCT6O9'
  $hostport = 'isbndb.com'
  $base_uri = "http://#{$hostport}/api/v2/json/#{$api_key}"
  
  # GET /books
  # GET /books.json
  def index
      @books = Book.search(params[:search])
      @hash = Gmaps4rails.build_markers(@books) do |book, marker|
          if book.availability and book.user.location
              user_link = view_context.link_to book.user.name, user_path(book.user.id)
              marker.lat book.user.location.latitude
              marker.lng book.user.location.longitude
              marker.picture ({
                  :url => view_context.image_path('marker.png'),
                  :width => 32,
                  :height => 32
                  })
              marker.infowindow "<h4><u>#{user_link}</u></h4>"
          end
      end
      #@books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
      @book_review = BookReview.new
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    response = find_by_isbn params[:book][:isbn]
    if response["error"]
        flash[:error] = "Sorry, the ISBNdb API couldn't process that ISBN"
        return redirect_to :back
    end
    data = response["data"][0]
      
    all_params = {}
    all_params[:user_id] = current_user.id
    all_params[:availability] = true
      
    if data["isbn13"] and data["isbn13"] != ""
        all_params[:isbn] = data["isbn13"]
    elsif data["isbn10"]
        all_params[:isbn] = data["isbn10"]
    end
      
    if data["title_long"] and data["title_long"] != ""
        all_params[:title] = data["title_long"]
    elsif data["title"]
        all_params[:title] = data["title"]
    end
    
    if data["subject_ids"] and data["subject_ids"][0]
        all_params[:genre] = data["subject_ids"][0]
    end
      
    @book = Book.new(all_params)
    
    author_params = {}
    if data["author_data"]
       data["author_data"].each { |author|
          if !Author.exists?(author_id: author["id"])
              author_params[:name] = author["name"]
              author_params[:author_id] = author["id"]
              @author = Author.new(author_params)
              @author.books << @book
              @author.save!
          else
              @book.authors << Author.find_by(author_id: author["id"])
          end
        } 
    end
    
    publisher_params = {}
    if data["publisher_name"] and data["publisher_id"]
        if !Publisher.exists?(publisher_id: data["publisher_id"])
            publisher_params[:name] = data["publisher_name"]
            publisher_params[:publisher_id] = data["publisher_id"]
            @publisher = Publisher.new(publisher_params)
            @publisher.books << @book
            @publisher.save!
        else
              @book.publisher = Publisher.find_by(publisher_id: data["publisher_id"])
        end
    end

    respond_to do |format|
      if @book.save
        format.html { redirect_to :back, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update      
      respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
    
  def post_review
      if params[:review]
          review_params = {}
          review_params[:user_id] = current_user.id
          review_params[:book_id] = @book.id
          review_params[:review] = params[:review]
          review_params[:rating] = params[:rating]
          review_params[:approved] = false
          
          @book_review = BookReview.new(review_params)
          respond_to do |format|
              if @book_review.save
                  format.html { redirect_to :back, notice: 'Your review has been queued up for admin moderation. It will be posted as soon as it is approved' }
              else
                  format.html { redirect_to :back, notice: 'Error while submitting book review!' }
              end
          end
      end
  end
    
  def delete_review
      BookReview.find(params[:id]).destroy
      respond_to do |format|
          format.html { redirect_to :back, notice: 'Book review was successfully deleted.' }
          format.json { head :no_content }
      end
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:user_id, :isbn, :title, :genre, :availability, :condition, :market_price, :publisher_id, :review, :image)
    end
    
    def find_by_isbn isbn
        @response = JSON.parse(HTTParty.get("#{$base_uri}/book/#{isbn.strip.delete('-')}"))
    end
end
