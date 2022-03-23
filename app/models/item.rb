class Item < ApplicationRecord

  attachment :image

  belongs_to :genre

  has_many :cart_items
  has_many :order_details

  enum is_active: { sale: true, stopsale: false }

  def self.search(keyword)
  where(["name like? OR introduction like?", "%#{keyword}%", "%#{keyword}%"])
  end

  def with_tax_price
    (price * 1.1).floor
  end
end