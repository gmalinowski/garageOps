# GarageOps — Workflow Summary

## Organization and Locations

- An **Organization** operates one or more **Locations**, each with a small team.
- **Customers** and **Vehicles** are shared across the organization's locations, including vehicle service history.
- Each **Service Order** belongs to an organization and a specific location.
- A shared database does not automatically grant access to another organization's data. Sharing between independent organizations remains undecided.
- Other core entities are **Users**, **Memberships**, **Work Items**, **Inventory Items**, **Stock Levels** and **Purchase Orders**. Parts used in a Service Order reference inventory items where applicable.

## Titles, Permissions and Profiles

Separate a person's descriptive title from their actual access. Authorization checks use permissions and scope, never a title or profile name.

| Concept | Purpose | Examples |
| --- | --- | --- |
| Title | Describes the person's job in the organization; grants no access. | Owner, Location Manager, Mechanic, Receptionist, Staff |
| Permissions | The operations this person is currently allowed to perform. | Record payments, order parts, assign advisors |
| Permission Profile | A reusable starting set of permissions applied when configuring someone's access. | Mechanic, Front Desk, Location Management, Organization Administration |
| Location Access | Defines where the person's location-bound permissions apply. | Location A only, or Locations A and B |

Titles are descriptive text on the organization membership, with optional location-specific titles where needed. The same title can accompany different permissions. Changing a title never changes access. Even the title **Owner** grants no automatic administrative privileges.

### Permission Profiles

Profiles belong to an organization and can be maintained by someone with **Manage Permission Profiles** permission.

| Default Profile | Starting Permissions |
| --- | --- |
| Mechanic | View local orders and shared vehicle/customer history; update findings, work items, parts information and issues. |
| Front Desk | View and create local orders, maintain customer/vehicle details, record received payments and issues. |
| Location Management | Coordinate any order in selected locations, assign advisors, order parts, manage local work and view local reports. Include refund, discount and payment-term permissions according to organization policy. |
| Organization Administration | Organization settings, locations, membership administration, profile editing and permission management, plus operational access across the organization. |

These are editable starting presets, not enforced job categories. A Mechanic title may use Front Desk permissions, and an employee can receive additional permissions without changing their title or applying another profile.

For the first version, **applying a profile copies its permissions into the member's access configuration**:

- Store the applied profile and version for reference. The person's saved permissions are the source of truth.
- Editing a profile affects future applications, not existing employees automatically.
- Grant or revoke individual permissions directly. There is no Inherit / Allow / Deny layer; a permission is granted or absent at its scope.
- Reapplying a profile to existing access is an explicit operation: choose **Add Missing Permissions** or **Replace Permissions**, preview the changes, and then save. Replace applies only to the selected scope and may remove individual grants there.
- A profile does not silently choose locations. Review its permission scope and Location Access before applying it.

### Individual Permissions and Scope

A permission answers **what** a person can do; its scope answers **where**. Store organization-level permissions on the membership and location-bound permissions for each authorized location. One person may have different permissions at different locations.

Adding another location does not require a new title or profile. Configure access and permissions for that location. Selected locations cover only those named locations; access to future locations requires an explicit organization-wide scope.

For example:

| Person | Title | Initial Profile | Current Access |
| --- | --- | --- | --- |
| Chris Lee | Mechanic | Mechanic | Standard mechanic permissions at Location A. |
| Jordan Smith | Mechanic | Mechanic | The same starting permissions at A, later extended with parts ordering and coordination of assigned orders. |
| Alex Morgan | Location Manager | Location Management | Management permissions at A and B. |
| Sam Parker | Location Manager | Location Management | Management permissions at C, with refunds and financial reports removed. |

Check access using active organization membership, the requested operation, the target's scope and any record conditions. Missing permissions mean no access. For location-bound operations, location access and the operation permission are both required. Shared Customer/Vehicle history is available within the organization to members with its read permissions; access to history does not grant permission to modify orders at other locations.

Permissions ending in `assigned` apply only when the person is Assigned Advisor; `any` covers every order in the authorized location. Assignment satisfies a record condition but does not create permissions.

### Initial Permission Catalog

| Permission | Allows |
| --- | --- |
| `service_orders.view` | View orders in the authorized location. |
| `service_orders.create` | Accept a new request. |
| `service_orders.assign_advisor` | Assign or replace an eligible advisor. |
| `service_orders.coordinate_assigned` | Manage estimates, record customer decisions and perform transitions on assigned orders. |
| `service_orders.coordinate_any` | Perform those coordination actions on any order in scope. |
| `work_items.update` | Record findings and work progress. |
| `parts.update` | Update required parts and delivery information. |
| `purchase_orders.create` | Prepare a draft purchase of parts, consumables or tools for an authorized location. |
| `purchase_orders.place` | Commit a purchase order to a supplier within the authorized location and organization rules. |
| `inventory.view` | View stock levels and item locations within the authorized scope. |
| `inventory.receive` | Record actual delivery quantities into a location's stock. |
| `inventory.adjust` | Correct stock quantities with a recorded reason. |
| `issues.manage` | Create, assign and resolve issues, including blockers. |
| `customers.view` / `customers.update` | Read shared customer records / create or update them. |
| `vehicles.view` / `vehicles.update` | Read shared vehicle history / create or update vehicle records. |
| `payments.record` | Record received payments. |
| `payments.refund` | Authorize a refund under organization rules. |
| `pricing.discount` | Authorize a discount under organization rules. |
| `payments.change_terms` | Authorize an exception to standard payment terms. |
| `reports.view` | View financial reports within the granted scope. |
| `memberships.manage` | Invite members and manage their membership status; does not itself grant permission-editing access. |
| `permissions.manage` | Configure individual permissions and Location Access within the administrator's authorized grant scope. |
| `permission_profiles.manage` | Create or edit reusable permission profiles. |
| `organization.manage` | Manage organization settings. |
| `locations.manage` | Create or configure locations within the granted scope. |

Profile editing and permission assignment are separate capabilities. Editing a profile does not grant its contents to the editor or to existing members. Applying a profile requires permission-management authority for every grant and location involved. Membership management alone cannot grant new privileges, including by applying a profile during an invitation.

The organization setup process explicitly grants its initial administrator the Organization Administration permissions and organization-wide scope. This is an access grant, not a special case based on the **Owner** title. Prevent removal of the last active organization access administrator until a replacement is configured.

### Staff & Permissions Screen

Keep **Title**, **Location Access** and **Permissions** separately editable in **Settings → Staff & Permissions**. Offer **Apply Permission Profile** to fill the initial permission selection, followed by individual changes. Show the actual granted permissions per scope and the last applied profile as reference only.

All title, profile and access changes record the actor, timestamp and previous/new values in Activity. Access revocation takes effect on subsequent requests. If a change removes an active advisor's required access, reassign their orders as part of that change; preserve all history.

New advisor assignments require an active member with location access and permission to coordinate that order. Permissions do not bypass workflow prerequisites or replace the customer's approval.

## Responsibility

- Each active order has one **Assigned Advisor**, responsible for coordinating diagnosis, estimates, customer decisions, parts, deadlines and collection.
- A newly received order may be unassigned. Someone with effective **Assign Advisor** permission assigns an advisor and moves it into **Assessment**. This permission is included in the initial management profiles and can be granted to any eligible member independently of title. Self-assignment follows the same permission and eligibility rules.
- The advisor does not have to perform repairs personally.
- Individual work items do not require mechanic assignments in the first version.
- Anyone can act as Assigned Advisor when they have location access and the required order-coordination permission, regardless of Title or the Permission Profile originally applied.
- **Activity** records who changed the order, what changed and when, including advisor reassignment and customer decisions.

## Service Order Status

Status describes the stage of vehicle service, independently of payment and outstanding issues.

| Label | Code | Meaning |
| --- | --- | --- |
| Received | `received` | The request is registered and needs an advisor. |
| Assessment | `assessment` | The advisor coordinates diagnosis and prepares the proposed scope, cost and completion date. |
| Awaiting Approval | `awaiting_approval` | The initial offer is ready and a customer decision is required. |
| In Progress | `in_progress` | The customer has approved work. The workshop arranges parts and performs the repair. |
| Ready for Collection | `ready_for_collection` | Work and handover checks are complete; the vehicle is prepared for collection. |
| Completed | `completed` | The vehicle has been handed over and the service workflow is closed. Payment follow-up may remain open. |
| Cancelled | `cancelled` | The order was withdrawn before diagnostic or repair work was performed. |

Main flow: **Received → Assessment → Awaiting Approval → In Progress → Ready for Collection → Completed**.

- A registered request does not necessarily mean that the vehicle has arrived. Record physical intake and collection separately.
- Diagnosis progress, estimate preparation, parts ordering and final checks are work details or Activity events, not additional order statuses.
- Record authorization for diagnostic scope and price or cost limit before starting paid diagnosis. Any agreed advance-payment prerequisite must also be met.
- Approval applies to specific work items and an estimate version. Record the scope, amount, decision, date, channel and the staff member recording it.
- A revised initial offer can return from **Awaiting Approval** to **Assessment**. Preserve previous estimates and decisions.
- Additional work requires a new approval. Already approved work may continue under **In Progress**; add a blocking issue only if further progress is prevented.
- If the visit ends after diagnosis or the customer declines all repairs, prepare the vehicle for collection and complete the order with a recorded outcome such as **Diagnosis Only**. Do not cancel work that has already been performed.
- Complete the final checklist before **Ready for Collection**. This status means ready for handover, not necessarily repaired or roadworthy; document unresolved faults and any transport restrictions.
- Resolve vehicle custody, parts commitments and advance-payment disposition before cancellation.
- **Completed** and **Cancelled** are terminal workflow states. A return visit can be recorded as a new linked order.
- Keep **Preferred Collection Date**, **Proposed Completion Date** and **Agreed Completion Date** distinct. Reception records the customer's preference without promising a repair deadline.

## Payments

Track charges, payment terms, received payments and refunds separately from the service workflow. Payment Status is derived from those records, not manually selected to advance the order.

| Label | Meaning |
| --- | --- |
| Not Due | No payment is currently required under the agreed terms. |
| Unpaid | There is an outstanding assessed amount with no payment applied to it. Show its due date separately. |
| Partially Paid | Part of the assessed amount has been paid. |
| Paid | The assessed amount has been covered. |

- An unpriced order is not automatically **Paid**. If an outstanding amount has been assessed but its due date is in the future, show **Unpaid** or **Partially Paid** with that future date. **Not Due** is for stages where no payment obligation currently applies.
- **Overdue** is a separate flag for an unpaid amount past its due date; it may accompany **Unpaid** or **Partially Paid**.
- **Refund Due** indicates money that must be returned. Track the refund amount and its completion separately.
- An advance payment reduces the order balance. Diagnostic charges and any agreed discount when repairs proceed are separate from the payment itself.
- **Paid** reflects recorded charges at that point; a later approved charge may change the balance and Payment Status.
- **Completed** does not require **Paid** when deferred payment has been agreed. An unpaid completed order still appears in financial follow-up.

## Issues and Blockers

An **Issue** is an outstanding matter requiring action. A **Blocker** is an open issue marked **Blocking**, meaning it prevents the next step in the service workflow. It is not an order substatus.

Each issue contains:

- **Reason** and **Description**.
- **Assigned To**, defaulting to the order's advisor.
- **Blocking** and a description of the step it prevents.
- **Follow-up Date**.
- **Open / Resolved**, with creation and resolution history.

Multiple issues can be open at once. Resolving one does not automatically resolve the others or advance the order status.

For the first version, blockers apply to the whole order. If useful approved work can continue, record a missing part in **Parts** or as a nonblocking issue instead of blocking the entire order.

Issues may be added at any stage. On terminal orders, new matters are follow-up issues rather than blockers of an already completed workflow. Resolve or explicitly convert existing blockers to follow-up issues when their blocking condition no longer applies; do not silently discard them at closure.

| Situation | Order Status | Issue / Other Information |
| --- | --- | --- |
| Diagnostic advance payment is required before work starts | Assessment | Blocking: **Advance Payment Required** |
| Approved work cannot proceed without a part | In Progress | Blocking: **Awaiting Parts** |
| Additional work needs approval but other work can continue | In Progress | Nonblocking: **Additional Approval Required** |
| Vehicle is ready but agreed payment is required before handover | Ready for Collection | Blocking: **Payment Required Before Collection** |
| Customer disputes the bill and collection cannot proceed | Ready for Collection | Blocking: **Billing Dispute** |
| Vehicle was collected with agreed deferred payment | Completed | Payment: **Unpaid**, with a future due date |
| Payment is overdue after collection | Completed | **Overdue** flag and nonblocking **Payment Follow-up** issue |

The same issue reason can be blocking or nonblocking depending on whether it actually prevents the next step. Customer response, vehicle arrival, parts, location transfer and technical problems follow the same rule.

## Inventory and Purchasing

Use **Inventory** for what the organization holds and **Purchase Orders** for what it is buying. These are separate from **Service Orders**, which represent customer vehicle visits.

### Inventory

The item catalog is shared across the organization, while physical quantities belong to individual locations. An item may be stocked at several locations.

| Category | Examples | Treatment |
| --- | --- | --- |
| Parts | Oil filter, brake pads, alternator | Can be reserved for and used on a Service Order. |
| Consumables | Engine oil, brake cleaner, gloves | Used during repairs or general workshop operations; track the appropriate unit, such as liters or pieces. |
| Tools & Equipment | Torque wrench, diagnostic scanner, jack | Remain workshop equipment after purchase; not consumed or billed as a repair part when used. |

Show **Item**, **Category**, **SKU / Part Number**, **Unit**, **Location**, **On Hand**, **Reserved** and **Available** for stock items. **Available = On Hand − Reserved**. Show tools with their quantity and storage location; individual tool checkout, servicing and asset accounting are outside the initial wireframe.

- A reservation earmarks stock for an order without reducing the physical On Hand quantity. Recording use reduces On Hand and releases the corresponding reservation.
- Ordered quantities are **Incoming**, not On Hand or Available. Increase stock only after receipt is recorded.
- Parts supplied by a customer are tracked against that customer's order; they do not become generally available workshop stock.
- A transfer between locations moves existing stock rather than creating a supplier purchase. Stock in transit is not available at either destination until its receipt is recorded.
- Record receipts, use, returns, transfers and corrections as stock movements with quantity, unit, location, date, actor and any related Service Order or Purchase Order.

### Purchase Orders

A Purchase Order has a supplier, receiving location, responsible person, expected delivery date and lines containing item, quantity and purchase unit price. One order can contain parts, consumables and tools.

For the first version, a Purchase Order can optionally link directly to one **Service Order** in the same organization. A Service Order can have multiple Purchase Orders. Leave the link empty for **General Purchase**, such as stock replenishment or workshop equipment. A linked purchase is dedicated to that repair; combining purchases for several repairs would require later line-level allocation.

Show the optional **Service Order** field in the purchase form, prefilled when starting a purchase from a repair. Display it as a link in the Purchase Orders list. The repair screen shows **Related Purchase Orders** with supplier, delivery status and purchase value. This association does not automatically charge the customer or reserve received stock.

| Status | Meaning |
| --- | --- |
| Draft | Needed items have been listed; no supplier commitment has been recorded. |
| Ordered | The purchase has been placed with the supplier. |
| Partially Received | Some quantities have arrived; others remain outstanding. |
| Received | All required delivery quantities have been received. |
| Cancelled | The purchase was cancelled before any receipt. |

- Record actual quantities received, including partial deliveries. Track cancellation of outstanding quantities per line after a partial receipt, preserving received stock and history.
- Delivery completion is independent of supplier payment. The initial wireframe does not need a supplier accounting module.
- Record a needed tool as a Draft Purchase Order line. A separate purchase-request approval workflow is not required for the initial concept; creating a draft and placing an order are separate permissions.
- Purchase cost and the price quoted to a repair customer are separate amounts. Receiving a tool does not add its price to a customer's repair estimate.
- The broader **Place Purchase Orders** permission replaces the previously proposed parts-only `parts.order` permission in the target model. Existing sample permission screens will need their labels aligned when purchasing wireframes are added.

### Connection to Service Orders

For each required part, the advisor can see stock at authorized locations, reserve available quantity, arrange a transfer or prepare a purchase for missing quantity. Link the relevant purchase line to the repair order for delivery tracking.

Example: **SO-2026-0104** needs one alternator at **Central Workshop**. Its purchase line belongs to **PO-2026-0021**. The supplier delivery is late, so the order shows an **Awaiting Parts** blocking issue. When the alternator is received, stock is recorded and reserved for the repair. The advisor verifies that the blocking condition is resolved; a receipt alone does not mark the repair completed.

### Wireframe Scope

Add two overview screens:

- **Inventory:** sample parts, consumables and tools with locations and quantities. Include one part stocked at two locations and one part reserved for a repair.
- **Purchase Orders:** sample purchases of repair parts, replenishment stock and tools, with supplier, receiving location, expected delivery and status.

One sample purchase detail can show mixed line items and a linked Service Order. No working stock ledger, supplier integration or purchasing automation is required to explain the concept.

## Service Order Screen and Dashboard

The Service Order header shows **Status**, **Location**, **Assigned Advisor**, **Payment Status** and **Next Action**. Display open blocking issues prominently and keep other issues accessible.

Use **Overview**, **Diagnosis & Estimate**, **Work & Parts**, **Payments** and **Activity** to organize the details. These can be separate pages under the same order navigation.

The Dashboard prioritizes **My Service Orders**, **Needs Attention** and **Upcoming Collections**. Needs Attention includes blocking issues, overdue follow-ups and payment problems on completed orders. Avoid a separate mechanic scheduling module in the first version.
