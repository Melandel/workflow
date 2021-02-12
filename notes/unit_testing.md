# Unit testing
* One file for each unit tested
* One test for each behavior/List classes of input for each test
|-- module_X
    |-- implementation
        `-- ClassToTest.cs
    |-- tests
        |-- ClassToTest
            |-- MethodToTest.cs
                |-- class InputBuilder
                    |-- InitializeWithStandardCaseValues
                    |-- SetPropertyOne()
                    |-- Build() => return new Input()
                |-- WHEN_happy_path_EXPECT_target_TO_DO/BE_something
                |-- WHEN_specified_as_out_of_scope_EXPECT_target_TO_[NOT_THROW/BE_undefined]
                |-- WHEN_specified_as_out_of_scope_EXPECT_target_TO_[NOT_THROW/BE_undefined]
            `-- MethodToTest2.cs
