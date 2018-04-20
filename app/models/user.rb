class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable    
    devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :lockable
       
    mount_uploader :image, ImageUploader
    validates_processing_of :image
    validate :image_size_validation
    
    validates_presence_of :name, :birth_date
    
    has_one :privilege
    
    has_many :books
    has_many :book_reviews
    
    has_many :notifications
    
    has_many :donations
    has_one :location
    
    has_many :reviewerships
    has_many :reviewers, :through => :reviewerships
    
    has_many :inverse_reviewerships, :class_name => "Reviewership", :foreign_key => 'reviewer_id'
    has_many :inverse_reviewers, :through => :inverse_reviewerships, :source => :user
    
    def send_devise_notification(notification, *args)
        devise_mailer.send(notification, self, *args).deliver_later
    end
    
    private
        def image_size_validation
            errors[:image] << "should be less than 500KB" if image.size > 0.5.megabytes
        end
end
