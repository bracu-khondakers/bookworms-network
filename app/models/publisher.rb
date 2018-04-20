class Publisher < ActiveRecord::Base
    #Contact Information
    has_many :websites, :as => :contactable, :class_name => "Website"
    has_many :emails, :as => :contactable, :class_name => "Email"
    has_many :phone_numbers, :as => :contactable, :class_name => "PhoneNumber"
    has_many :addresses, :as => :contactable, :class_name => "Address"
    
    has_many :books
end
