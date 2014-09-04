module Shoppe
  class Order < ActiveRecord::Base

    self.table_name = 'shoppe_orders'
  
    # Orders can have properties
    key_value_store :properties    
    
    # Require dependencies
    require_dependency 'shoppe/order/states'
    require_dependency 'shoppe/order/actions'
    require_dependency 'shoppe/order/billing'
    require_dependency 'shoppe/order/delivery'
    
    # All items which make up this order
    has_many :order_items, :dependent => :destroy, :class_name => 'Shoppe::OrderItem'
    accepts_nested_attributes_for :order_items, :allow_destroy => true, :reject_if => Proc.new { |a| a['ordered_item_id'].blank? }

    # All products which are part of this order (accessed through the items)
    has_many :products, :through => :order_items, :class_name => 'Shoppe::Product', :source => :ordered_item, :source_type => 'Shoppe::Product'
    
    # Validations
    validates :token, :presence => true
    with_options :if => Proc.new { |o| !o.building? } do |order|
      order.validates :email_address, :format => {:with => /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i}
      order.validates :phone_number, :format => {:with => /\A[\d\ \-x\(\)]{7,}\z/}
    end
  
    # Set some defaults
    before_validation { self.token = SecureRandom.uuid  if self.token.blank? }
    
    # The order number
    #
    # @return [String] - the order number padded with at least 5 zeros
    def number
      id ? id.to_s.rjust(6, '0') : nil
    end
  
    # The length of time the customer spent building the order before submitting it to us.
    # The time from first item in basket to received.
    #
    # @return [Float] - the length of time
    def build_time
      return nil if self.received_at.blank?
      self.created_at - self.received_at
    end
  
    # The name of the customer in the format of "Company (First Last)" or if they don't have
    # company specified, just "First Last".
    #
    # @return [String]
    def customer_name
      company.blank? ? full_name : "#{company} (#{full_name})"
    end
    
    # The full name of the customer created by concatinting the first & last name
    #
    # @return [String]
    def full_name
      "#{first_name} #{last_name}"
    end

    # The hash with billing_address
    #
    # @return [Hash]
    def billing_address
      address = {}
      address[:first_name] = self.first_name if self.first_name
      address[:last_name] = self.last_name if self.last_name
      address[:name] = self.first_name + " " + self.last_name if self.first_name
      address[:company] = self.company if self.company
      address[:address1] = self.billing_address1 if self.billing_address1
      address[:address2] = self.billing_address2 if self.billing_address2
      address[:address3] = self.billing_address3 if self.billing_address3
      address[:address4] = self.billing_address4 if self.billing_address4
      address[:postcode] = self.billing_postcode if self.billing_postcode
      address[:country] = Shoppe::Country.find(self.billing_country_id).name if self.billing_country_id

      address
    end

    # The hash with delivery address
    #
    # Logic is: if all attributes for custom delivery address is filled use them, or use billing address.
    #
    # @return [Hash]
    def delivery_address
      address = {}

      if (self.delivery_address1 && !self.delivery_address1.empty?) && (self.delivery_address2 && !self.delivery_address2.empty?) && (self.delivery_postcode && !self.delivery_postcode.empty?) && (self.delivery_country_id && (!self.delivery_country_id.is_a? Integer))
        address[:name] = self.delivery_name
        address[:address1] = self.delivery_address1 if self.delivery_address1
        address[:address2] = self.delivery_address2 if self.delivery_address2
        address[:address3] = self.delivery_address3 if self.delivery_address3
        address[:address4] = self.delivery_address4 if self.delivery_address4
        address[:postcode] = self.delivery_postcode if self.delivery_postcode
        address[:country] = Shoppe::Country.find(self.delivery_country_id).name if self.delivery_country_id
      else
        address[:name] = self.first_name + " " + self.last_name if self.first_name && self.last_name
        address[:address1] = self.billing_address1 if self.billing_address1
        address[:address2] = self.billing_address2 if self.billing_address2
        address[:address3] = self.billing_address3 if self.billing_address3
        address[:address4] = self.billing_address4 if self.billing_address4
        address[:postcode] = self.billing_postcode if self.billing_postcode
        address[:country] = Shoppe::Country.find(self.billing_country_id).name if self.billing_country_id
      end

      address
    end
  
    # Is this order empty? (i.e. doesn't have any items associated with it)
    #
    # @return [Boolean]
    def empty?
      order_items.empty?
    end
  
    # Does this order have items?
    #
    # @return [Boolean]
    def has_items?
      total_items > 0
    end
  
    # Return the number of items in the order?
    #
    # @return [Integer]
    def total_items
      order_items.inject(0) { |t,i| t + i.quantity }
    end
    
    def self.ransackable_attributes(auth_object = nil) 
      ["id", "billing_postcode", "billing_address1", "billing_address2", "billing_address3", "billing_address4", "first_name", "last_name", "company", "email_address", "phone_number", "consignment_number", "status", "received_at"] + _ransackers.keys
    end
  
    def self.ransackable_associations(auth_object = nil)
      []
    end
  
  end
end
