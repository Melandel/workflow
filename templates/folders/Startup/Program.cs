using Microsoft.Extensions.DependencyInjection;

namespace startup
{
	class Program
	{
		public static void Main(string[] args)
		{
			var serviceProvider = BuildServiceProvider();
			var obj = serviceProvider.GetService<Contract.INumberProvider>();
			System.Console.WriteLine(obj.Provide());
		}

		private static ServiceProvider BuildServiceProvider()
		{
			var serviceProvider = new ServiceCollection()
				.AddSingleton<Contract.INumberProvider, Implementation.OneProvider>()
				.BuildServiceProvider();
			return serviceProvider;
		}
	}
}
