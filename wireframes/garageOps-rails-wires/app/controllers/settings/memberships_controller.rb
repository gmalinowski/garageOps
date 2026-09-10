module Settings
  class MembershipsController < ApplicationController
    def index
      @memberships = sample_memberships
    end

    def show
      @membership = sample_memberships.find { |member| member[:id] == params[:id] }
      raise ActiveRecord::RecordNotFound, "Membership not found" unless @membership

      @permission_labels = {
        "service_orders.view" => "View Service Orders",
        "service_orders.create" => "Create Service Orders",
        "service_orders.assign_advisor" => "Assign Advisor",
        "service_orders.coordinate_assigned" => "Coordinate Assigned Orders",
        "service_orders.coordinate_any" => "Coordinate Any Order",
        "work_items.update" => "Update Work Items",
        "parts.update" => "Update Parts Information",
        "parts.order" => "Order Parts",
        "issues.manage" => "Manage Issues & Blockers",
        "customers.view" => "View Customers",
        "customers.update" => "Update Customers",
        "vehicles.view" => "View Vehicles & History",
        "vehicles.update" => "Update Vehicles",
        "payments.record" => "Record Payments",
        "payments.refund" => "Authorize Refunds",
        "reports.view" => "View Financial Reports"
      }
    end

    private

    def sample_memberships
      # Read-only wireframe data. Profiles are copied starting points, not live role rules.
      mechanic = %w[service_orders.view work_items.update parts.update issues.manage customers.view vehicles.view]
      front_desk = %w[service_orders.view service_orders.create customers.view customers.update vehicles.view vehicles.update payments.record issues.manage]
      management = (mechanic + front_desk + %w[service_orders.assign_advisor service_orders.coordinate_assigned service_orders.coordinate_any parts.order payments.refund reports.view]).uniq

      [
        {
          id: "1", name: "Taylor Brooks", title: "Owner", email: "taylor.brooks@example.com", status: "Active",
          joined: "12 Jan 2026", profile: "Organization Administration", profile_version: "1",
          locations: [{ name: "All Locations", permissions: management }],
          organization_permissions: ["Manage Organization", "Manage Locations", "Manage Memberships", "Manage Permissions & Location Access", "Manage Permission Profiles"],
          notes: "Organization-wide access was explicitly granted at setup. The Owner title does not grant permissions.",
          activity: [{ date: "12 Jan 2026", actor: "Organization setup", detail: "Applied Organization Administration v1 and explicitly granted access to all current and future locations." }],
          orders: []
        },
        {
          id: "2", name: "Alex Morgan", title: "Location Manager", email: "alex.morgan@example.com", status: "Active",
          joined: "15 Jan 2026", profile: "Location Management", profile_version: "1",
          locations: [{ name: "Central Workshop", permissions: management }, { name: "North Workshop", permissions: management - %w[payments.refund] }],
          organization_permissions: [], notes: "Manages two locations. Refund authorization is granted only at Central Workshop.",
          activity: [{ date: "08 Sep 2026", actor: "Taylor Brooks", detail: "Added North Workshop access without refund authorization." }, { date: "15 Jan 2026", actor: "Taylor Brooks", detail: "Applied Location Management v1 at Central Workshop." }],
          orders: [{ number: "SO-2026-0107", vehicle: "Toyota Yaris" }, { number: "SO-2026-0105", vehicle: "Volkswagen Golf" }, { number: "SO-2026-0103", vehicle: "Skoda Octavia" }]
        },
        {
          id: "3", name: "Sam Parker", title: "Location Manager", email: "sam.parker@example.com", status: "Active",
          joined: "02 Feb 2026", profile: "Location Management", profile_version: "1",
          locations: [{ name: "Central Workshop", permissions: management - %w[payments.refund reports.view] }],
          organization_permissions: [], notes: "Coordinates local orders. Refund authorization and financial reports have been removed from this member's permissions.",
          activity: [{ date: "07 Sep 2026", actor: "Taylor Brooks", detail: "Removed refund and financial-report permissions at Central Workshop." }, { date: "02 Feb 2026", actor: "Taylor Brooks", detail: "Applied Location Management v1." }],
          orders: [{ number: "SO-2026-0106", vehicle: "BMW 320d" }, { number: "SO-2026-0104", vehicle: "Ford Transit" }, { number: "SO-2026-0102", vehicle: "Kia Ceed" }]
        },
        {
          id: "4", name: "Chris Lee", title: "Mechanic", email: "chris.lee@example.com", status: "Active",
          joined: "10 Mar 2026", profile: "Mechanic", profile_version: "1",
          locations: [{ name: "Central Workshop", permissions: mechanic }],
          organization_permissions: [], notes: "Updates findings, work and parts information. No permission to place parts orders or coordinate a service order.",
          activity: [{ date: "10 Mar 2026", actor: "Taylor Brooks", detail: "Applied Mechanic v1 at Central Workshop." }], orders: []
        },
        {
          id: "5", name: "Jordan Smith", title: "Mechanic", email: "jordan.smith@example.com", status: "Active",
          joined: "10 Mar 2026", profile: "Mechanic", profile_version: "1",
          locations: [{ name: "Central Workshop", permissions: mechanic + %w[parts.order service_orders.coordinate_assigned] }],
          organization_permissions: [], notes: "Started with the same profile as Chris Lee. Can now order parts and coordinate orders when assigned as Advisor. The title remains Mechanic.",
          activity: [{ date: "09 Sep 2026", actor: "Taylor Brooks", detail: "Granted Order Parts and Coordinate Assigned Orders at Central Workshop." }, { date: "10 Mar 2026", actor: "Taylor Brooks", detail: "Applied Mechanic v1." }], orders: []
        },
        {
          id: "6", name: "Riley Adams", title: "Receptionist", email: "riley.adams@example.com", status: "Active",
          joined: "01 Jun 2026", profile: "Front Desk", profile_version: "1",
          locations: [{ name: "Central Workshop", permissions: front_desk }],
          organization_permissions: [], notes: "Accepts requests, maintains customer and vehicle records, and records received payments. Advisor assignment requires another authorized member.",
          activity: [{ date: "01 Jun 2026", actor: "Taylor Brooks", detail: "Applied Front Desk v1 at Central Workshop." }], orders: []
        },
        {
          id: "7", name: "Casey Reed", title: "Mechanic", email: "casey.reed@example.com", status: "Invited",
          joined: nil, profile: "Mechanic", profile_version: "1",
          locations: [{ name: "North Workshop", permissions: mechanic }],
          organization_permissions: [], notes: "Invitation pending. The configured permissions become effective only after the invitation is accepted and membership is active.",
          activity: [{ date: "10 Sep 2026", actor: "Taylor Brooks", detail: "Sample invitation created with Mechanic v1 for North Workshop. No real invitation was sent." }], orders: []
        }
      ]
    end
  end
end
