class InventoryItemsController < ApplicationController
  def index
    # Sample stock by location; incoming quantities are not available stock.
    @inventory_items = [
      { name: "Oil Filter", sku: "FLT-001", category: "Parts", location: "Central Workshop", unit: "pcs", on_hand: 8, reserved: 2, incoming: 0 },
      { name: "Oil Filter", sku: "FLT-001", category: "Parts", location: "North Workshop", unit: "pcs", on_hand: 3, reserved: 0, incoming: 0 },
      { name: "Alternator", sku: "ALT-TR-01", category: "Parts", location: "Central Workshop", unit: "pcs", on_hand: 0, reserved: 0, incoming: 1, purchase: "PO-2026-0021", order: "SO-2026-0104" },
      { name: "Drive Belt", sku: "BLT-TR-01", category: "Parts", location: "Central Workshop", unit: "pcs", on_hand: 1, reserved: 1, incoming: 0, order: "SO-2026-0104" },
      { name: "Engine Oil 5W-30", sku: "OIL-530", category: "Consumables", location: "Central Workshop", unit: "L", on_hand: 20, reserved: 5, incoming: 0 },
      { name: "Engine Oil 5W-30", sku: "OIL-530", category: "Consumables", location: "North Workshop", unit: "L", on_hand: 5, reserved: 0, incoming: 20, purchase: "PO-2026-0023" },
      { name: "Nitrile Gloves", sku: "GLV-M", category: "Consumables", location: "Central Workshop", unit: "boxes", on_hand: 6, reserved: 0, incoming: 4, purchase: "PO-2026-0022" },
      { name: "Torque Wrench", sku: "TLS-TW-01", category: "Tools & Equipment", location: "Central Workshop", unit: "pcs", on_hand: 1, reserved: 0, incoming: 0, storage: "Tool cabinet A" },
      { name: "Diagnostic Scanner", sku: "TLS-DS-01", category: "Tools & Equipment", location: "North Workshop", unit: "pcs", on_hand: 1, reserved: 0, incoming: 0, storage: "Diagnostic bay" }
    ]
  end
end
