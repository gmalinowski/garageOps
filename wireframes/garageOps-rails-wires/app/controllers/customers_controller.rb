class CustomersController < ApplicationController
  def index
    # Sample data for the wireframe; no database records are created.
    @customers = [
       { id: "CUST-001", name: "James Wilson", kind: "Individual", email: "james.wilson@example.com", phone: "+48 000 000 101", vehicle: "Volvo V70", registration: "WX 4821K", vehicle_id: "VEH-001", order: "SO-2026-0108" },
      { id: "CUST-002", name: "Emma Taylor", kind: "Individual", email: "emma.taylor@example.com", phone: "+48 000 000 102", vehicle: "Toyota Yaris", registration: "WA 7392P", vehicle_id: "VEH-002", order: "SO-2026-0107" },
      { id: "CUST-003", name: "Oliver Brown", kind: "Individual", email: "oliver.brown@example.com", phone: "+48 000 000 103", vehicle: "BMW 320d", registration: "WU 1058C", vehicle_id: "VEH-003", order: "SO-2026-0106" },
      { id: "CUST-004", name: "Sophie Martin", kind: "Individual", email: "sophie.martin@example.com", phone: "+48 000 000 104", vehicle: "Volkswagen Golf", registration: "WE 6214N", vehicle_id: "VEH-004", order: "SO-2026-0105" },
      { id: "CUST-005", name: "Northside Delivery Ltd", kind: "Company", email: "fleet@example.com", phone: "+48 000 000 105", contact: "Morgan Reed · Fleet Manager", vehicle: "Ford Transit", registration: "WI 9032F", vehicle_id: "VEH-005", order: "SO-2026-0104" },
      { id: "CUST-006", name: "Daniel Harris", kind: "Individual", email: "daniel.harris@example.com", phone: "+48 000 000 106", vehicle: "Skoda Octavia", registration: "WP 5186J", vehicle_id: "VEH-006", order: "SO-2026-0103" },
      { id: "CUST-007", name: "Charlotte Evans", kind: "Individual", email: "charlotte.evans@example.com", phone: "+48 000 000 107", vehicle: "Kia Ceed", registration: "WB 3470R", vehicle_id: "VEH-007", order: "SO-2026-0102" },
      { id: "CUST-008", name: "Liam Walker", kind: "Individual", email: "liam.walker@example.com", phone: "+48 000 000 108", vehicle: "Renault Clio", registration: "WD 8629L", vehicle_id: "VEH-008", order: "SO-2026-0101" }
    ]
  end
end
