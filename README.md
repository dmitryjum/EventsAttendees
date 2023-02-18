# README
- The EventAttendees API server accepts requests and allows to create, update, delete, return a list of events or just one event. It also allows to RSVP to an event via creation of Attendee record with "rsvp_status" property "yes" and it allows to create Attendee record with its "rsvp_status" property "no", associated with an event in a role of invitation.
Events can be queried by ID or "FriendlyId" slugged to an event name. When one event is requested, it returns as json with its own properties and with paginated list of related attendees.
- Attendee resource on its own would likely be accessed by the admin user. The API allows to query Attendees table by ID or FriendlyId; create a new Attendee, but it's creation requires existing event and its association with an existing event. An admin can also delete and update an Attendee record, but there can't be more than one Attendee record with the same email that belongs to the same Event, although email property doesn't have to be unique on its own

###API responds to these Events routes:###
1. `GET /v1/events` - It returns all events with no params, passed and the server responds with JSON that would look like:
 ```{"records"=>
  [{"id"=>1,
    "name"=>"Event one",
    "start_time"=>"2022-03-15T00:00:00.000Z",
    "end_time"=>"2022-03-22T00:00:00.000Z",
    "description"=>"Voluptates similique recusandae dignissimos cupiditate. Veniam facilis cum consequuntur itaque voluptatum reprehenderit. Quaerat repudiandae fugit labore distinctio.",
    "event_type"=>"in_person",
    "created_at"=>"2023-02-18T15:36:08.820Z",
    "updated_at"=>"2023-02-18T15:36:08.820Z",
    "slug"=>"event-one"}],
 "entries_count"=>1,
 "pages_per_limit"=>1,
 "page"=>1}
 ```
2. Additional params can be passed to the main route to filter down the returned list of Event records as in `GET /v1/events?event.start_time=2022-03-15&per_page=2` which would return the same JSON response, but narrowed down to your queries
3. A single Event can be requested by its ID or Friendly Id as follows: `GET /v1/events/1?page=1`. Page query is customary and it allows you to select the page of the attendees list that related to your requested Event. The response would look approximately like that:
```
"updated_at"=>"2023-02-18T15:49:17.500Z",
 "slug"=>"event-one",
 "attendees"=>
  {"records"=>
    [{"id"=>1, "name"=>"Adriana Donnelly", "email"=>"brian_medhurst@abshire.com", "rsvp_status"=>"no", "event_id"=>1, "created_at"=>"2023-02-18T15:49:17.509Z", "updated_at"=>"2023-02-18T15:49:17.509Z", "slug"=>"adriana-donnelly"},
     {"id"=>2, "name"=>"Milan Koelpin", "email"=>"heidy.lubowitz@lynchabbott.name", "rsvp_status"=>"no", "event_id"=>1, "created_at"=>"2023-02-18T15:49:17.511Z", "updated_at"=>"2023-02-18T15:49:17.511Z", "slug"=>"milan-koelpin"},
     {"id"=>3, "name"=>"Leslie Rowe", "email"=>"antwan@bailey.info", "rsvp_status"=>"no", "event_id"=>1, "created_at"=>"2023-02-18T15:49:17.514Z", "updated_at"=>"2023-02-18T15:49:17.514Z", "slug"=>"leslie-rowe"}
    ],
   "entries_count"=>10,
   "pages_per_limit"=>2,
   "page"=>1}}
   ```
4. A user can create a new Event via this route `POST /v1/events?event.description=modern+special+secret+event&event.event_type=in_person&even.name=New+Modern+Event`. And the example successful response would look like this:
```
{"id"=>4, "name"=>"New Modern Event", "start_time"=>nil, "end_time"=>nil, "description"=>"modern special secret event", "event_type"=>nil, "created_at"=>"2023-02-18T15:54:32.835Z", "updated_at"=>"2023-02-18T15:54:32.835Z", "slug"=>"new-modern-event"}
```
It's important to note, that "name" property is required and must be unique.
5. A user can update an existing event via this route `PATCH /v1/events/1?event.name=Event+Ninety+Nine` and response would just your updated event object with your new name.
6. A user can delete an existing event via this route `DELETE /v1/events/3`. There will be empty response body in return with 204 status code.
7. One of the main features of this API is RSVP action. A user can RSVP to an event which will result in creation of a new Attendee record if it doesn't exist with its "rsvp_status" property set to "yes" (it's "no" by default). The appropriate route to RSVP is: `POST /v1/events/3/rsvp?attendee.email=john@email.com&attendee.name=John`. It's important to pass "name" and "email" propertie with RSVP POST request, as they are required to reate an Attendee record.

###API responds to these Attendees routes:###
There is no Index route for Attendees, as the list of them can be requested per the Event that they belong to. But there are other utility routes available, if Attendees table needs to be manipulated separately.
1. An attendee can be accessed by ID or Friendly ID via `GET /v1/attendees/1` and the example response would be:
```
{
  "id"=>1,
  "name"=>"John Doe",
  "email"=>"izetta@sanford.com",
  "rsvp_status"=>"yes",
  "event_id"=>1,
  "created_at"=>"2023-02-18T16:14:26.336Z",
  "updated_at"=>"2023-02-18T16:14:26.336Z",
  "slug"=>"john-doe"
}
```
2. You'll have to hit this route to create a new Attendee (an event has to exist and you have to know its id): `POST /v1/attendees?attendee.email=yan@witting.com&attendee.name=Vinnie+Conroy&event_id=1`. And the appropriate response is:
```
{
  "id"=>2,
 "name"=>"Vinnie Conroy",
 "email"=>"yan@witting.com",
 "rsvp_status"=>"no",
 "event_id"=>1,
 "created_at"=>"2023-02-18T16:17:08.404Z",
 "updated_at"=>"2023-02-18T16:17:08.404Z",
 "slug"=>"vinnie-conroy"
}
```
Again: "email" is a required field.
3. `PATCH /v1/attendees/1?attendee.rsvp_status=no` end point will update your event. In response you'll receive the same event, but with your updated property
4. `DELETE /v1/attendees/1` will delete an attendee accordingly. There will be empty response body in return with 204 status code.

### Technologies used
* Ruby 3.2.1
* Rails 7.0.4
* Postgres 14.6

### Running instructions
Make sure you have Ruby, Rails and Postgres versions available
### Install all gems
Install bundler if it isn't installed yet:  `gem bundler install`<br />
Install app gems `bundle install`
### Set up the DB
`rails db:create`
### Run DB migrations
`rails db:migrate`
### Seed the DB with image records
`rails db:seed`
### Run tests
`rspec`
### Run the application
You can start just the application by running `rails s`. It'll start on default port 3000.
### See available routes
`rails routes`<br />
### Notes
Use Postman app or similar to make test requests. Read test suite to learn all potential functionality.

