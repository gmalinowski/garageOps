class PurchaseOrdersController < ApplicationController
  def index
    @purchase_orders = SamplePurchaseOrders.all
  end
end
