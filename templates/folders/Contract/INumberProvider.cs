#if COMPILE_TESTS
using Xunit;
#endif

namespace Contract
{
	public interface INumberProvider
	{
		int Provide();


#if COMPILE_TESTS
		public abstract class Behavior
		{
			public abstract FixtureBuilder FixtureBuilder { get; }

			[Fact]
			protected virtual void ReturnTheNumberOne()
			{
				// Arrange
				var environment = FixtureBuilder.Init(FixtureBase.HappyPath)
					.Build();
				var sut = environment.SystemUnderTest;

				// Act & Assert
				Assert.Equal(1, sut.Provide());
			}
		}


		public enum FixtureBase { HappyPath }
		public abstract class Fixture {
			public abstract INumberProvider SystemUnderTest { get; }
		}
		public abstract class FixtureBuilder {
			public abstract FixtureBuilder Init(FixtureBase fixtureBase);
			// Add some methods here to have a convenient API for building test environments
			public abstract Fixture Build();
		}
#endif
	}
}
