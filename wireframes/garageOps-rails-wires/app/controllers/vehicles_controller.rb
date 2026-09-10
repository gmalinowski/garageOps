class VehiclesController < ApplicationController
  def index
    # Sample data for the wireframe; mileage is recorded at the latest intake.
    @vehicles = [
      { id: "VEH-001", name: "Volvo V70", year: 2015, engine: "2.0 D4 · Diesel", registration: "WX 4821K", mileage: 185420, customer: "James Wilson", customer_id: "CUST-001", order: "SO-2026-0108" },
      { id: "VEH-002", name: "Toyota Yaris", year: 2019, engine: "1.5 · Petrol", registration: "WA 7392P", mileage: 62410, customer: "Emma Taylor", customer_id: "CUST-002", order: "SO-2026-0107" },
      { id: "VEH-003", name: "BMW 320d", year: 2017, engine: "2.0 · Diesel", registration: "WU 1058C", mileage: 163800, customer: "Oliver Brown", customer_id: "CUST-003", order: "SO-2026-0106" },
      { id: "VEH-004", name: "Volkswagen Golf", year: 2018, engine: "1.4 TSI · Petrol", registration: "WE 6214N", mileage: 112650, customer: "Sophie Martin", customer_id: "CUST-004", order: "SO-2026-0105" },
      { id: "VEH-005", name: "Ford Transit", year: 2020, engine: "2.0 EcoBlue · Diesel", registration: "WI 9032F", mileage: 241300, customer: "Northside Delivery Ltd", customer_id: "CUST-005", order: "SO-2026-0104" },
      { id: "VEH-006", name: "Skoda Octavia", year: 2016, engine: "2.0 TDI · Diesel", registration: "WP 5186J", mileage: 209150, customer: "Daniel Harris", customer_id: "CUST-006", order: "SO-2026-0103" },
      { id: "VEH-007", name: "Kia Ceed", year: 2021, engine: "1.5 T-GDi · Petrol", registration: "WB 3470R", mileage: 48320, customer: "Charlotte Evans", customer_id: "CUST-007", order: "SO-2026-0102" },
      { id: "VEH-008", name: "Renault Clio", year: 2018, engine: "0.9 TCe · Petrol", registration: "WD 8629L", mileage: 89740, customer: "Liam Walker", customer_id: "CUST-008", order: "SO-2026-0101" }
    ]
  end
end
