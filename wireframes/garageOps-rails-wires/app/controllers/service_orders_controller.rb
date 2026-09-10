class ServiceOrdersController < ApplicationController

  def index
    # Sample data for the wireframe; no database records are created.
    @service_orders = [
      {
        number: "SO-2026-0108", customer: "James Wilson", vehicle: "Volvo V70", registration: "WX 4821K",
        issue: "Front suspension noise and ABS warning light", status: "Received", status_class: "badge-neutral",
        priority: "High", advisor: nil, quoted_total: nil, completion_on: nil
      },
      {
        number: "SO-2026-0107", customer: "Emma Taylor", vehicle: "Toyota Yaris", registration: "WA 7392P",
        issue: "Engine struggles to start when cold", status: "Awaiting diagnosis", status_class: "badge-info",
        priority: "Normal", advisor: "Alex Morgan", quoted_total: nil, completion_on: nil
      },
      {
        number: "SO-2026-0106", customer: "Oliver Brown", vehicle: "BMW 320d", registration: "WU 1058C",
        issue: "Loss of power under acceleration", status: "Diagnosing", status_class: "badge-info",
        priority: "High", advisor: "Sam Parker", quoted_total: nil, completion_on: nil
      },
      {
        number: "SO-2026-0105", customer: "Sophie Martin", vehicle: "Volkswagen Golf", registration: "WE 6214N",
        issue: "Replace front brake discs and pads", status: "Awaiting approval", status_class: "badge-warning",
        priority: "Normal", advisor: "Alex Morgan", quoted_total: 1480, completion_on: Date.new(2026, 9, 14)
      },
      {
        number: "SO-2026-0104", customer: "Northside Delivery Ltd", vehicle: "Ford Transit", registration: "WI 9032F",
        issue: "Replace alternator and drive belt", status: "Awaiting parts", status_class: "badge-warning",
        priority: "High", advisor: "Sam Parker", quoted_total: 2350, completion_on: Date.new(2026, 9, 15)
      },
      {
        number: "SO-2026-0103", customer: "Daniel Harris", vehicle: "Skoda Octavia", registration: "WP 5186J",
        issue: "Timing belt replacement and oil service", status: "In progress", status_class: "badge-primary",
        priority: "Normal", advisor: "Alex Morgan", quoted_total: 2800, completion_on: Date.new(2026, 9, 11)
      },
      {
        number: "SO-2026-0102", customer: "Charlotte Evans", vehicle: "Kia Ceed", registration: "WB 3470R",
        issue: "Annual service and cabin filter replacement", status: "Ready for collection", status_class: "badge-success",
        priority: "Normal", advisor: "Sam Parker", quoted_total: 690, completion_on: Date.new(2026, 9, 10)
      },
      {
        number: "SO-2026-0101", customer: "Liam Walker", vehicle: "Renault Clio", registration: "WD 8629L",
        issue: "Battery replacement and charging system check", status: "Completed", status_class: "badge-ghost",
        priority: "Low", advisor: "Alex Morgan", quoted_total: 520, completion_on: Date.new(2026, 9, 9)
      }
    ]
  end

  def new

  end

  def create

  end
end
