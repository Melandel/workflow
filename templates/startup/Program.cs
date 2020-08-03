using System;
using Microsoft.Extensions.DependencyInjection;

namespace HelloWorld.ConsoleApp
{
	class Program
	{
		static void Main(string[] args)
		{
			var serviceProvider = new ServiceCollection()
				.BuildServiceProvider();

			Console.WriteLine("Hello World!");
		}
	}
}
