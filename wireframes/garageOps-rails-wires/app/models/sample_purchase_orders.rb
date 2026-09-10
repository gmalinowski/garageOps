class SamplePurchaseOrders
  def self.all
    # Sample purchases; no orders are sent to suppliers.
    [
      { number: "PO-2026-0024", supplier: "Example Workshop Tools", location: "North Workshop", owner: "Alex Morgan", status: "Draft", badge: "badge-ghost", expected: "Not confirmed", purpose: "Workshop equipment", lines: [{ name: "Torque Wrench", quantity: 1, unit: "pcs", price: 320, received: 0 }] },
      { number: "PO-2026-0023", supplier: "Example Lubricants", location: "North Workshop", owner: "Alex Morgan", status: "Ordered", badge: "badge-info", expected: "12 Sep 2026", purpose: "Stock replenishment", lines: [{ name: "Engine Oil 5W-30", quantity: 20, unit: "L", price: 35, received: 0 }] },
      { number: "PO-2026-0022", supplier: "Example Workshop Supplies", location: "Central Workshop", owner: "Sam Parker", status: "Partially Received", badge: "badge-warning", expected: "11 Sep 2026", purpose: "Workshop supplies", lines: [{ name: "Nitrile Gloves", quantity: 10, unit: "boxes", price: 18, received: 6 }] },
      { number: "PO-2026-0021", supplier: "Example Auto Parts", location: "Central Workshop", owner: "Sam Parker", status: "Partially Received", badge: "badge-warning", expected: "09 Sep 2026", overdue: true, purpose: "Customer repair", service_order_number: "SO-2026-0104", lines: [{ name: "Alternator", quantity: 1, unit: "pcs", price: 1450, received: 0 }, { name: "Drive Belt", quantity: 1, unit: "pcs", price: 150, received: 1 }] },
      { number: "PO-2026-0020", supplier: "Example Auto Parts", location: "Central Workshop", owner: "Alex Morgan", status: "Received", badge: "badge-success", expected: "Received 08 Sep 2026", purpose: "Stock replenishment", lines: [{ name: "Oil Filter", quantity: 8, unit: "pcs", price: 45, received: 8 }] },
      { number: "PO-2026-0019", supplier: "Example Workshop Tools", location: "North Workshop", owner: "Alex Morgan", status: "Cancelled", badge: "badge-ghost", expected: "Not applicable", purpose: "Equipment purchase withdrawn", lines: [{ name: "Hydraulic Jack", quantity: 1, unit: "pcs", price: 680, received: 0 }] }
    ]
  end
end
