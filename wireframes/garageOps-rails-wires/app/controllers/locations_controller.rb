class LocationsController < ApplicationController
  def index
    # Fictional directory entries for the wireframe, independent of location selection.
    @locations = [
      {
        name: "Central Workshop", address: ["12 Example Street", "00-001 Warsaw, Poland"],
        phone: "+48 000 000 201", email: "central@example.com", manager: "Alex Morgan",
        hours: [["Monday–Friday", "08:00–18:00"], ["Saturday", "09:00–14:00"], ["Sunday", "Closed"]],
        services: ["Diagnostics", "General Repairs", "Scheduled Maintenance"],
        arrival_notes: "Customer reception is at the main entrance. Leave the vehicle in a marked customer parking space and bring the keys to reception."
      },
      {
        name: "North Workshop", address: ["48 Sample Avenue", "01-001 Warsaw, Poland"],
        phone: "+48 000 000 202", email: "north@example.com", manager: "Alex Morgan",
        hours: [["Monday–Friday", "07:00–16:00"], ["Saturday", "Closed"], ["Sunday", "Closed"]],
        services: ["Diagnostics", "General Repairs", "Fleet Service"],
        arrival_notes: "Use the side entrance for vehicle drop-off. Call the location before arranging a vehicle transfer or delivery of parts."
      }
    ]
  end
end
