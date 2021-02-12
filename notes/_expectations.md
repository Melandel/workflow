# Things to try and aim at all times

## Architecture

<div style="display: flex"><div style="flex: 50%; max-width: 50%;">

### Product (_aka_ "Details")
* details, details, details...
	* **Startup project**
		* unit tests about bad configuration
		* unit tests about help, version details, documentation
		* generated unit tests about bad dependency injection
	* **I/O Delivery Mechanism (UI/API)**
		* **user-specific** input format
		* **user-specific** output format
		* half of the unit tests about responses homogeneity (error formats, etc)
		* half of the unit tests about contract management shenanigans (current and obsolete merged contracts, etc)
			* using mocked application logic
	* **Gateways**
		* **technology-specific** persistence implementations
</div><div style="flex: 50%; max-width: 50%;">

### Application
* specific only to the fictional, ideal client for the current domain representation
* represents at all times the current application concepts
* **UseCaseObjects**
	* call gateways, object methods, and services from:
		* the domain space [that-which-exists-only-because-computers]
		* the application space [that-which-would-have-existed-even-without-computers]
	* define the interfaces for gateways in:
		* the domaine space
		* the application space
	* return the application response to:
		* domain requests
		* application request
	* unit tests use mocked gateways
* **Application Objects&Services**
	* represent at all times the current application concepts
	* unit tests don't need any mock

### Domain
* represents at all times the current domain understanding
* **Domain Object&Service**
	* manipulate **Value Objects**
* **Value Objects**
	* objects for which equality exists, but identity does not matter
</div></div>

## Tests written by developers

### Test doubles definitions
* no framework
* defined exclusively inside the same assembly as their interface definition

### Suite of unit tests
* as fast as possible
* as few as possible, while covering _as many_ business rules _as possible_
	* _ie_ only `public` classes

### Component interaction tests
* as few as possible. Literally. There should be one everytime a component talks to another
* test that the pipes work. Do not test if the right answers are sent, and if the right responses are sent

### Other tests
* should be more focused about functionality
* leave that job to the testers
* they'll test if the pipes are called with the right requests and responses

## Awareness about latest tools, formats, standards and features available
* Keep an eye on evolutions and changelogs for tools and third parties

Who are you?
	A man who wants to create high quality projects


## Work Items

## Continuous Integration&Deployment

## Documentation & Welcome

## Values

# How should it show everyday?
## Checklist for every dev
* Current project
	* number of warnings?
	* renaming?
	* indentation?
	* unit test execution time?
	* nugets are up-to-date?
	* latest `csproj` format?
	* readme?
	* git log?
	* scripting?
	* number of classes?
	* xml documentation on top of class name?
	* duplicated code?

What are the most important things I expect from a code base?
	A great suite of unit tests
	A great suite of mocks
	A great clean architecture
	Up-to-date formats, libs & tools
What are the most important things I expect from task ?
	Example values / Scenarios Tests
	Context
	Bonus: An explanation on current behavior & implementation (& context)
What are the most important things I expect from ci/cd?
	Quick feedback
What are the most important things I expect from production monitoring?
	Logs & Bugs
What are the most important things for newcomers to get started?
	Install script
	Event Storm board to browse
	A guided tour
	Official resources
	Basic:
		howtos
		architecture diagrams
		glossary
		processes
		resources
		technological choices

What do you need?
	People aligned with that notion of quality and with knowledge on how to not make many mistakes
	Extending technical expertise
	Spreading technical expertise
	Tracking technologies

What will you do?
	A steady bit, every day.
	Do your job. Priority.
		But take time. Quick wins first.
			Readme

