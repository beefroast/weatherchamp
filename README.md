# WeatherChamp
Technical Challenge submission for employment.

## Objective
Create a simple app that displays a list of cities along with weather data, and allows a user to create and delete entries. The list should be sortable and the data should persist between runs.

## Decisions and Assumptions


#### No External Dependencies
For ease of use, I decided to forgo using any CocoaPods dependencies. This would allow anyone to (theoretically) clone the project and run it right out of the box, without having to install any additional tools.

#### Document Folder Storage
I decided to store City data in a simple JSON format in the documents folder, as CoreData felt like overkill for this non-relational data. I didn't persist the data online, doing so would be very easy if I were using external dependencies like Firebase or some other equivalent.

#### No Character Restricting Validation
I usually opt not to disallow characters from being entered into UITextFields, as it can make it very difficult for people with external input devices (such as Braille Readers) to correctly enter data. I guide the user by presenting the keyboard that best suits the task, but then validate on what they've entered.


## Potential Improvements
While writing this I made a bunch of decisions, mostly for the sake of simplicity that could be improved in future work. A 2-4 hour estimate of time is a little frugal (I spent roughly 8 or so hours), but I did want to get a slick, if not extremely Spartan, user experience.

- Could show a message if there are currently no cities.
- Asynchronous data fetching, went for the synchronous route mostly to keep it simple
- Actual UUIDs on the City model object, I'm using a 'good enough' solution for now, but it's not difficult to implement.
- More code coverage on UIViewController subclasses.
- Images for each of the weather categories, currently it's just an empty UIImageView but I think the intention is clear.

-----
Thanks for you time
