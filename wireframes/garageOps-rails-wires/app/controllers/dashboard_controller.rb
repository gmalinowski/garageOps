class DashboardController < ApplicationController
  def index
    # A fixed snapshot keeps the wireframe consistent with the sample service orders.
    @snapshot_date = Date.new(2026, 9, 10)
    @workshop_stats = [
      { label: "Active Service Orders", value: 7, detail: "1 additional order completed" },
      { label: "Awaiting Diagnosis", value: 1, detail: "1 more diagnosis in progress" },
      { label: "Awaiting Approval", value: 1, detail: "Customer decision needed" },
      { label: "Ready for Collection", value: 1, detail: "Collection scheduled for today" }
    ]
    @attention_items = [
      {
        number: "SO-2026-0108", vehicle: "Volvo V70", customer: "James Wilson",
        label: "Unassigned", badge_class: "badge-error", advisor: "Unassigned",
        detail: "Front suspension noise and ABS warning light. Assign an advisor and arrange the initial assessment."
      },
      {
        number: "SO-2026-0105", vehicle: "Volkswagen Golf", customer: "Sophie Martin",
        label: "Awaiting Approval", badge_class: "badge-warning", advisor: "Alex Morgan",
        detail: "The PLN 1,480.00 estimate was sent 2 days ago. Follow up before confirming the proposed completion date."
      },
      {
        number: "SO-2026-0104", vehicle: "Ford Transit", customer: "Northside Delivery Ltd",
        label: "Parts Delivery Overdue", badge_class: "badge-warning", advisor: "Sam Parker",
        detail: "The alternator was expected yesterday. Check with the supplier and review the 15 Sep completion target."
      }
    ]
    @todays_tasks = [
      {
        time: "09:00–11:00", number: "SO-2026-0106", vehicle: "BMW 320d",
        task: "Diagnose loss of power", mechanic: "Chris Lee", bay: "Bay 1",
        status: "In progress", badge_class: "badge-primary"
      },
      {
        time: "10:00–15:00", number: "SO-2026-0103", vehicle: "Skoda Octavia",
        task: "Replace timing belt and service oil", mechanic: "Jordan Smith", bay: "Bay 2",
        status: "In progress", badge_class: "badge-primary"
      },
      {
        time: "13:00–14:00", number: "SO-2026-0107", vehicle: "Toyota Yaris",
        task: "Diagnose cold-start problem", mechanic: "Chris Lee", bay: "Bay 1",
        status: "Scheduled", badge_class: "badge-ghost"
      }
    ]
    @upcoming_collections = [
      {
        number: "SO-2026-0102", vehicle: "Kia Ceed", customer: "Charlotte Evans",
        time: "Today · 16:00", status: "Ready for collection", badge_class: "badge-success",
        detail: "Final checks complete. Customer notified."
      },
      {
        number: "SO-2026-0103", vehicle: "Skoda Octavia", customer: "Daniel Harris",
        time: "Tomorrow · 15:00", status: "In progress", badge_class: "badge-primary",
        detail: "Agreed collection time. Repair and final checks still to be completed."
      }
    ]
  end
end
