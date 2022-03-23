class OrderDetail < ApplicationRecord

  belongs_to :order
  belongs_to :item

  enum making_status: { cannot_manufactured: 0, waiting_manufactured: 1, making: 2, complete_manufactured: 3 }

end