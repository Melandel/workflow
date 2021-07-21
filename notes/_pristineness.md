# A Pristine code repository

An attempt at formulating a _direction_ I want to lean towards. Not to be used as _expectations_.

## First Commits
```
.
|-- README.md
|-- Domain
    |-- ArchitecturalConcepts
        `-- Domain.ArchitecturalConcepts.csproj
    |-- Module_D1
        `-- Domain.Module_D1.csproj
    `-- Module_D2
        `-- Domain.Module_D2.csproj
|-- ApplicationName
    |-- ArchitecturalConcepts
        `-- ApplicationName.ArchitecturalConcepts.csproj
    |-- UseCases
        `-- Module_A1
            |-- Contract
                `-- ApplicationName.UseCases.Module_A1.Contract.csproj
            |-- Implementation
                `-- ApplicationName.UseCases.Module_A1.Implementation.csproj
            `-- Implementation.Repositories
                |-- Contract
                    `-- ApplicationName.UseCases.Module_A1.Repositories.Contract.csproj
                `-- InMemoryImplementation
                    `-- ApplicationName.UseCases.Module_A1.Repositories.InMemoryImplementation.csproj
    `-- Module_A2
        |-- Contract
            `-- ApplicationName.Module_A2.Contract.csproj
        |-- Implementation
            `-- ApplicationName.Module_A2.Implementation.csproj
        `-- Implementation.Repositories
            |-- Contract
                `-- ApplicationName.Module_A2.Repositories.Contract.csproj
            `-- InMemoryImplementation
                `-- ApplicationName.Module_A2.Repositories.InMemoryImplementation.csproj
`-- ApplicationName.ProductName
    |-- Startup
        `-- ApplicationName.ProductName.Startup.csproj
    |-- Module_A1.Repositories.Implementation
        `-- ApplicationName.ProductName.Module_A1.Repositories.Implementation.csproj
    |-- Module_A2.Repositories.Implementation
        `-- ApplicationName.ProductName.Module_A2.Repositories.Implementation.csproj
    `-- ProductPolicies
        `-- ApplicationName.ProductName.ProductPolicies.csproj
```

```
dotnet new sln -o Application.Product -n Product
dotnet new console -o Application.Product\Product
dotnet new classlib -o Application\UseCases\ModuleA\Contract                             -n Application.UseCases.ModuleA.Contract
dotnet new classlib -o Application\UseCases\ModuleA\Implementation                       -n Application.UseCases.ModuleA.Implementation
dotnet new classlib -o Application\UseCases\ModuleA\Implementation.Repositories\Contract               -n Application.UseCases.ModuleA.Repositories.Contract
dotnet new classlib -o Application\UseCases\ModuleA\Implementation.Repositories\InMemoryImplementation -n Application.UseCases.ModuleA.Repositories.InMemoryImplementation
dotnet new classlib -o Application.Product\Product.ModuleA.Repositories
dotnet new classlib -o Domain\Module1 -n Domain.Module1
dotnet new classlib -o Domain\ArchitecturalConcepts               -n Domain.ArchitecturalConcepts
dotnet new classlib -o Application\UseCases\ArchitecturalConcepts -n Application.UseCases.ArchitecturalConcepts
dotnet new classlib -o Application\Concerns\Logging   -n Application.Concerns.Logging
dotnet new classlib -o Application\Concerns\Security  -n Application.Concerns.Security
dotnet new classlib -o Application\Concerns\Licensing -n Application.Concerns.Licensing

dotnet add Domain\Module1                                                                  reference Domain\ArchitecturalConcepts
dotnet add Application\UseCases\ModuleA\Implementation.Repositories\Contract               reference Domain\Module1
dotnet add Application\UseCases\ModuleA\Implementation.Repositories\InMemoryImplementation reference Application\UseCases\ModuleA\Implementation.Repositories\Contract
dotnet add Application.Product\Product.ModuleA.Repositories                                reference Application\UseCases\ModuleA\Implementation.Repositories\Contract
dotnet add Application\UseCases\ModuleA\Implementation                                     reference Application\UseCases\ModuleA\Implementation.Repositories\Contract Application\UseCases\ModuleA\Contract Application\UseCases\ArchitecturalConcepts

dotnet add Application.Product\Product\ reference Application\UseCases\ModuleA\Contract Application\UseCases\ModuleA\Implementation Application\UseCases\ModuleA\Implementation.Repositories\Contract Application.Product\Product.ModuleA.Repositories Domain\Module1 Domain\ArchitecturalConcepts Application\UseCases\ArchitecturalConcepts
dotnet sln Application.Product add -s Startup                        Application.Product\Product
dotnet sln Application.Product add -s Architecture                   Domain\ArchitecturalConcepts
dotnet sln Application.Product add -s Architecture                   Application\UseCases\ArchitecturalConcepts
dotnet sln Application.Product add -s Domain                         Domain\Module1
dotnet sln Application.Product add -s Application.UseCases\ModuleA   Application\UseCases\ModuleA\Contract
dotnet sln Application.Product add -s Application.UseCases\ModuleA   Application\UseCases\ModuleA\Implementation
dotnet sln Application.Product add -s Application.UseCases\ModuleA   Application\UseCases\ModuleA\Implementation.Repositories\Contract
dotnet sln Application.Product add -s Application.UseCases\ModuleA   Application\UseCases\ModuleA\Implementation.Repositories\InMemoryImplementation
dotnet sln Application.Product add -s Application.UseCases\ModuleA   Application.Product\Product.ModuleA.Repositories
dotnet sln Application.Product add -s Application.UseCases\ModuleA   Application.Product\Product.ModuleA.Repositories
dotnet sln Application.Product add -s Application.Concerns           Application\Concerns\Logging
dotnet sln Application.Product add -s Application.Concerns           Application\Concerns\Security
dotnet sln Application.Product add -s Application.Concerns           Application\Concerns\Licensing
```

## Order of Development for a new feature
* **Première phase**
    * **UseCase.Interface**
    * **UseCase.AbstractUnitTest**
    * **UseCase.DummyImplementation** (implémentation 100% fake [if => return])
    * itérer jusqu'à avoir tous les unit tests concrets sur le UseCase qui passent [concret = tout est 100% faké] ainsi que 100% des cas de test
    * **Controller**: brancher les UseCases à un endpoint qui peut tourner
    * Un petit test manuel pour voir si l'API/le produit tourne avec cette version dummy
* Après cette première phase, on a déployé  un contrat binaire auquel un projet qui nous consomme peut déjà se brancher
* **Deuxième phase**
    * **UseCase.RealImplementation**
    * mais avec une **version InMemory du repository**
    * donc pas mal de choses à créer (le **vrai code du Use Case**, les** vrais Domain Objects**, des **tests unitaires sur ces objets Domain**, l'**interface du repository**, et l'implémentation InMemory du repository)
    * continuer jusqu'à avoir tous les unit tests concrets sur le UseCase qui passent [concret = utilise une version InMemory du repository]
* Après cette deuxième phase, on a déployé une implémentation pas mal fonctionnelle sur laquelle un projet qui nous consomme peut se brancher et tester déjà plus en profondeur
* **Troisième phase**
    * **Repository.RealImplementation**
    * continuer jusqu'à avoir tous les unit tests concrets sur le UseCase qui passent [concret = utilise la version finale du repository]
    * mais bien sûr, au niveau CI/CD, on continue d'utiliser la version InMemory du repository pour la vitesse
    * et il ne sera principalement intéressant de re-tester avec la vraie base de donnée que en cas de frayeur majeure/changement de techno/1 ou 2 fois par an
* Après cette troisième phase, on a déployé une implémentation qui satisfait le client mais il reste un stakeholder dont il faut s'occuper
* **Quatrième phase**
    * Dans le commit final, expliquer le contexte **métier** qui a débouché sur ces modifications de code (contexte métier, valeur métier dans ce contexte, choix d'implémentation, alternatives, raisonnement, choses à faire et à ne pas faire, go/nogo pour décisions futures)
    * Dans l'architecture decision log, expliquer les décisions **techniques** prises (contexte technique, valeur technique dans ce contexte, choix d'implémentation, alternatives, raisonnement, choses à faire et à ne pas faire, go/nogo pour décisions futures)
    * Si besoin est, on pourra générer un wiki/site statique à partir de ces données
* Après cette quatrième phase, on a laissé les informations à la postérité pour pouvoir **questionner/apprendre sainement** pourquoi le code est dans cet état-là, et s'il y a un sens à vouloir le **changer** dans telle ou telle autre direction

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
