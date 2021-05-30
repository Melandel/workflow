using Contract;

namespace Implementation
{
	public class OneProvider : INumberProvider
	{
		int INumberProvider.Provide() => 1;


#if COMPILE_TESTS
		public class Should : INumberProvider.Behavior {
			public override INumberProvider.FixtureBuilder FixtureBuilder => new FixtureBuilder();
		}

		public class Fixture : INumberProvider.Fixture {
			public override INumberProvider SystemUnderTest => new OneProvider();
		}

		public class FixtureBuilder : INumberProvider.FixtureBuilder {
			public override INumberProvider.FixtureBuilder Init(INumberProvider.FixtureBase fixtureBase) => this;
			public override INumberProvider.Fixture        Build() => new Fixture();
		}
#endif
	}
}
