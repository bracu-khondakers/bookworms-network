class Deal < ActiveRecord::Base
    has_one :response, dependent: :destroy
    has_one :notification
    belongs_to :buyer, :class_name => 'User', :foreign_key => 'buyer_id'
    belongs_to :seller, :class_name => 'User', :foreign_key => 'seller_id'
    belongs_to :book
end
