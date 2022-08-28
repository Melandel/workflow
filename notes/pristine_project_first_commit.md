# pristine_project_first_commit
mkdir src
dotnet     new sln


dotnet     new classlib -n APPNAME.Domain
dotnet sln add             APPNAME.Domain
echo "The Domain layer declares the notions, interactions and rules that compose a business." > APPNAME.Domain/README.md
echo "`n## Code expected here"                                                               >> APPNAME.Domain/README.md
echo "* Objects named after Domain concepts                                                  >> APPNAME.Domain/README.md
echo "* Services named after Domain concepts                                                 >> APPNAME.Domain/README.md
echo "`n## Code NOT expected here"                                                           >> APPNAME.Domain/README.md
echo "* References to infrastructure concepts(web, databse, view, etc)                       >> APPNAME.Domain/README.md
echo "`n## Other guidelines"                                                                 >> APPNAME.Domain/README.md


dotnet     new classlib -n APPNAME.Application
dotnet     add             APPNAME.Application reference APPNAME.Domain
dotnet sln add             APPNAME.Application
echo "The Application layer orchestrates domain layer objects and also adds notions, external service providers APIs, interactions and rules proper to an application." > APPNAME.Application/README.md
echo "`n## Code expected here"                                                                                                                                         >> APPNAME.Application/README.md
echo "`n## Code NOT expected here"                                                                                                                                     >> APPNAME.Application/README.md
echo "`n## Other guidelines"                                                                                                                                           >> APPNAME.Application/README.md

dotnet     new nunit    -n APPNAME.Application.Behavior.Tests
dotnet     add             APPNAME.Application.Behavior.Tests reference APPNAME.Application
dotnet sln add             APPNAME.Application.Behavior.Tests
echo "The Application tests (behavior) project specifies the contract interface and behavior that should be implemented by the application." > APPNAME.Application.Behavior.Tests/README.md
echo "`n## Tests expected here"                                                                                                             >> APPNAME.Application.Behavior.Tests/README.md
echo "`n## Tests NOT expected here"                                                                                                         >> APPNAME.Application.Behavior.Tests/README.md
echo "`n## Other guidelines"                                                                                                                >> APPNAME.Application.Behavior.Tests/README.md


dotnet     new classlib -n APPNAME.ServiceProviders
dotnet     add             APPNAME.ServiceProviders reference APPNAME.Application.BehaviorSpecification
dotnet     add             APPNAME.ServiceProviders reference APPNAME.Domain
dotnet sln add             APPNAME.ServiceProviders
echo "The ServiceProviders project provides service providers implementations matching the needs defined inside the application." > APPNAME.ServiceProviders/README.md
echo "`n## Code expected here"                                                                                                   >> APPNAME.ServiceProviders/README.md
echo "`n## Code NOT expected here"                                                                                               >> APPNAME.ServiceProviders/README.md
echo "`n## Other guidelines"                                                                                                     >> APPNAME.ServiceProviders/README.md

dotnet     new nunit    -n APPNAME.ServiceProviders.UnitTests
dotnet     add             APPNAME.ServiceProviders.UnitTests reference APPNAME.ServiceProviders
dotnet sln add             APPNAME.ServiceProviders.UnitTests
echo "The ServiceProviders-unit-tests project provides confidence that nothing get lost in translation between our code and a service provider." > APPNAME.ServiceProviders.UnitTests/README.md
echo "`n## Tests expected here"                                                                                                                 >> APPNAME.ServiceProviders.UnitTests/README.md
echo "* tests for each mapped field"                                                                                                            >> APPNAME.ServiceProviders.UnitTests/README.md
echo "* tests for exceptions thrown"                                                                                                            >> APPNAME.ServiceProviders.UnitTests/README.md
echo "* tests for behavior when the service provider returns null"                                                                              >> APPNAME.ServiceProviders.UnitTests/README.md
echo "`n## Tests NOT expected here"                                                                                                             >> APPNAME.ServiceProviders.UnitTests/README.md
echo "`n## Other guidelines"                                                                                                                    >> APPNAME.ServiceProviders.UnitTests/README.md

dotnet     new nunit    -n APPNAME.ServiceProviders.StatusTests
dotnet     add             APPNAME.ServiceProviders.StatusTests reference APPNAME.ServiceProviders
dotnet sln add             APPNAME.ServiceProviders.StatusTests
echo "The ServiceProviders-status-tests project provides unambiguous, up-to-date information whether a service provider is ready-to-use or not." > APPNAME.ServiceProviders.StatusTests/README.md
echo "`n## Tests expected here"                                                                                                                 >> APPNAME.ServiceProviders.StatusTests/README.md
echo "`n## Tests NOT expected here"                                                                                                             >> APPNAME.ServiceProviders.StatusTests/README.md
echo "`n## Other guidelines"                                                                                                                    >> APPNAME.ServiceProviders.StatusTests/README.md


dotnet     new web      -n APPNAME.Api
dotnet sln add             APPNAME.Api
dotnet     add             APPNAME.Api reference APPNAME.Application
echo "The Api layer is responsible for translating input and output between the web paradigm and the application paradigm." > APPNAME.Api/README.md
echo "`n## Code expected here"                                                                                             >> APPNAME.Api/README.md
echo "`n## Code NOT expected here"                                                                                         >> APPNAME.Api/README.md
echo "`n## Other guidelines"                                                                                               >> APPNAME.Api/README.md

dotnet     new             APPNAME.Api.Client
dotnet sln add             APPNAME.Api.Client
echo "The client project provides a programmatic way for consumers to use the application." > APPNAME.Api.Client/README.md
echo "`n## Code expected here"                                                             >> APPNAME.Api.Client/README.md
echo "`n## Code NOT expected here"                                                         >> APPNAME.Api.Client/README.md
echo "`n## Other guidelines"                                                               >> APPNAME.Api.Client/README.md

dotnet     new web      -n APPNAME.Dto
dotnet sln add             APPNAME.Dto
dotnet     add             APPNAME.Dto
dotnet     add             APPNAME.Api        reference APPNAME.Dto
dotnet     add             APPNAME.Api.Client reference APPNAME.Dto
echo "The Dto project implements the data structures passed between a client and a server." > APPNAME.Dto/README.md
echo "`n## Code expected here"                                                             >> APPNAME.Dto/README.md
echo "`n## Code NOT expected here"                                                         >> APPNAME.Dto/README.md
echo "`n## Other guidelines"                                                               >> APPNAME.Dto/README.md

dotnet     new nunit    -n APPNAME.Application.IO.Tests
dotnet     add             APPNAME.Application.IO.Tests reference APPNAME.Api.Client
dotnet     add             APPNAME.Application.IO.Tests reference APPNAME.Api
dotnet sln add             APPNAME.Application.IO.Tests
echo "The application-input&output-mapping-tests project provides confidence that nothing gets lost in translation between a consumer (client) and the application." > APPNAME.Application.IO.Tests/README.md
echo "`n## Tests expected here"                                                                                                                                     >> APPNAME.Application.IO.Tests/README.md
echo "`n## Tests NOT expected here"                                                                                                                                 >> APPNAME.Application.IO.Tests/README.md
echo "`n## Other guidelines"                                                                                                                                        >> APPNAME.Application.IO.Tests/README.md
