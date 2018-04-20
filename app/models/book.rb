class Book < ActiveRecord::Base    
    belongs_to :user
    belongs_to :publisher
    has_and_belongs_to_many :authors
    has_many :book_reviews
    
    #In case you want to turn on ImageUpload for books
    #mount_uploader :image, ImageUploader
    #validates_processing_of :image
    #validate :image_size_validation
    
    def self.search(search)
        if search != ''
            where(['title LIKE ? OR isbn LIKE ?', "%#{search}%", "%#{search}%"])
        else
            return Book.none
        end
    end
    
    #private
    #    def image_size_validation
    #        errors[:image] << "should be less than 500KB" if image.size > 0.5.megabytes
    #    end
end
