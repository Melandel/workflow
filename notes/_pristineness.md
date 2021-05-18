# A Pristine code repository

An attempt at formulating a _direction_ I want to lean towards. Not to be used as _expectations_.

## First Commits
```
.
|-- README.md
|-- Domain
    |-- Module_D1
        `-- Domain.Module_D1.csproj
    `-- Module_D2
        `-- Domain.Module_D2.csproj
|-- ApplicationName
    |-- UseCases
        `-- Module_A1
            |-- Contracts
                `-- ApplicationName.UseCases.Module_A1.Contracts.csproj
            |-- Implementations
                `-- ApplicationName.UseCases.Module_A1.Implementations.csproj
            |-- Implementations.Gateways.Contracts
                `-- ApplicationName.UseCases.Module_A1.Implementations.Gateways.Contracts.csproj
            `-- DummyImplementations
                `-- ApplicationName.UseCases.Module_A1.DummyImplementations.csproj
    |-- Module_A2
        |-- Contracts
            `-- ApplicationName.Module_A2.Contracts.csproj
        |-- Implementations
            `-- ApplicationName.Module_A2.Implementations.csproj
        |-- Implementations.Gateways.Contracts
            `-- ApplicationName.Module_A2.Implementations.Gateways.Contracts.csproj
        |-- DummyImplementations
            `-- ApplicationName.Module_A2.DummyImplementations.csproj
    `-- ReusableCode
        `-- Topic1
            `-- ApplicationName.ReusableCode.Topic1.csproj
`-- ProductName
    |-- Startup
    |-- IO
        |-- ProductName.IO.csproj
        |-- Module_P1
        `-- Module_P2
    |-- Module_P1.Gateways.Implementations
        `-- ProductName.Module_P1.Gateways.Implementations.csproj
    |-- Module_P1.ThirdParty
        `-- ProductName.Module_P1.ThirdParty.csproj
    |-- Module_P2.Gateways.Implementations
        `-- ProductName.Module_P2.Gateways.Implementations.csproj
    `-- ReusableCode
        `-- Topic1
            `-- ProductName.ReusableCode.Topic1.csproj
```

## Logs

Given the following architecture

```puml_sequence
@startuml
actor "User/UI" as User
participant "Controller" as Controller
participant "Module1" as M1
participant "Module2" as M2
participant "Module3" as M3

User -> Controller
Controller -> M1
M1 -> M2
Controller -> M3
Controller --> User
@enduml
```

The exhaustive list of logs should be:
* At the Controller level:
	* [INFO] Requests received **as a result of a User action**
	* [INFO] Requests received that happen only occasionally (initialization typically)
* At every level:
	* [INFO]  Information about the runtime lifetime (boot/reboot/initialization typically)
	* [ERROR] Runtime exceptions regarding the system's behaviour
	* [WARN]  Exceptions linked to something else (the system's configuration or the availability of its dependencies typically)
	* [WARN]  Non-happypath turns of events that are not exceptions

## Architecture

```puml_sequence
@startuml
[-> Controller:some form\nof input 
participant "Controller" as Controller

box "Core"
participant "UseCase\nObject" as UseCaseObject
participant "Gateway\nInterfaces" as IGateways
endbox

participant "Gateway\nImplementation(s)" as Gateways

Controller -> UseCaseObject ++ :UseCaseRequest
UseCaseObject -> "Gateway\nInterfaces" as IGateways: GET
IGateways -> Gateways
Gateways <--]: some form\nof persisted data
IGateways --> UseCaseObject: Domain or Application Objects
||75||
note right of UseCaseObject: calls\nDomain or Application Objects\nmethods
||75||
UseCaseObject -> IGateways: FLUSH
IGateways -> Gateways
Gateways ->]: some form\nof data persistence
UseCaseObject --> Controller -- :UseCaseResponse
?<-- Controller:some form\nof output
@enduml
```
<div style="display: flex"><div style="flex: 50%; max-width: 50%;">

### Core

#### Domain Layer
* represents at all times the current domain understanding
* **Domain Object&Service**
	* manipulate **Value Objects**
* **Value Objects**
	* objects for which equality exists, but identity does not matter

#### Application Layer
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
	* unit tests mock gateways and only gateways
</div><div style="flex: 50%; max-width: 50%;">

### Details

#### Product Layer
* details, details, details...
* **Startup project**
	* unit tests about bad configuration
	* unit tests about help, version details
	* generated unit tests about bad dependency injection
* **I/O Delivery Mechanism (UI/API)**
	* **user-specific** input&output format
	* **technology-specific** constraints
	* half of the unit tests about responses homogeneity (error formats, etc)
	* half of the unit tests about contract management shenanigans (current and obsolete merged contracts, etc)
		* using mocked application logic
* **Gateways**
	* **technology-specific** persistence implementations
</div></div>

## Tests
<div style="display: flex"><div style="flex: 50%; max-width: 50%;">

### Developer Needs
#### Suite of unit tests
* as fast as possible
* as few as possible, while covering _as many_ business rules _as possible_
	* _ie_ only `public` classes

#### Test doubles definitions
* no framework
* defined exclusively inside the same assembly as their interface definition

#### External Dependency behaviour validation tests
* run only when dependency version has changed or another dependency is used for the same job
</div><div style="flex: 50%; max-width: 50%;">

### Product Owner Needs
#### Other integrated tests
* should be more focused about functionality
* leave that job to the testers
* they'll test if the pipes are called with the right requests and responses
</div></div>

## Input/Output & Tooling

<div style="display: flex"><div style="flex: 50%; max-width: 50%;">

### User Stories
* Current behaviour of the system (high level context)
	* Example structure:
		* Given...
		* When...
		* The system currently...
* Presentation of the unmet need
	* Example structure:
		* In order to...
		* As...
		* I want...
* General Idea Tests
	* define the user story's scope

### Tasks
* Current behaviour of the system (technical low level context)
	* Links to the implementation in the code
* Presentation of the behaviour to implement
* Acceptance tests
	* define the user story's scope
	* define the logs to create
</div><div style="flex: 50%; max-width: 50%;">

### Work with the latest tooling, standards & features
* Be aware of them
* Keep an eye on evolutions and changelogs for tools and third parties

### Continuous Integration
* Fast (under 5 minutes)
* Guarantees every revision committed is testable
	* no compilation error
	* no runtime errors such as bad configuration or bad dependency injection

### Continuous Deployment
</div></div>

## Newcomer Integration
<div style="display: flex"><div style="flex: 50%; max-width: 50%;">

### Documentation System Presentation
* how to look for an information?
* RTFM culture
* `doc/`
	* `media/`
		* used by markdown files
	* `getstarted.*.md`
		* tutorials (overview of the features of a tool)
	* `howto.*.md`
		* guides for completing a precise action
			* install dev desktop
			* compile
			* build
			* create test environment
	* `reference.*.md`
		* factual descriptions and pieces of information
			* event storming
			* processes
			* architecture
			* workflows
			* team structures
			* git repositories organization
	* `lets.*.md`
		* decision records: problem statement, decision drivers, considered options
			* use decision records
			* implement this
			* have that discipline
	* `craft/`
		* technology watch
		* agile software development watch
		* software craftmanship watch
		* resources
		* blog posts
</div><div style="flex: 50%; max-width: 50%;">

### Getting Started
* double click on a script
* after that, introduce the mentor

### Team Building
* coffee invitations
* games
</div></div>

## How should it show everyday?
<div style="display: flex"><div style="flex: 50%; max-width: 50%;">

### Generate a report on a regular basis
</div><div style="flex: 50%; max-width: 50%;">

### Checklist for PRs
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
</div></div>
