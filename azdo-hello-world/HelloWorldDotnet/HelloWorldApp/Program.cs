// using System;

// namespace HelloWorldApp
// {
//     class Program
//     {
//         static void Main(string[] args)
//         {
//             Console.WriteLine("Hello, World! This is Tej signing up");
//         }
//     }
// }

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;

namespace HelloWorldApp
{
    public class Program
    {
        public static void Main(string[] args)
        {
            try
            {
                CreateHostBuilder(args).Build().Run();
            }
            catch (Exception ex)
            {
                // Log any exceptions that cause the application to crash
                Console.WriteLine($"Application startup failed: {ex.Message}");
                throw;
            }
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.ConfigureServices(services =>
                    {
                        services.AddControllers();
                    });

                    webBuilder.Configure((context, app) =>
                    {
                        var env = context.HostingEnvironment;
                        var logger = app.ApplicationServices.GetRequiredService<ILogger<Program>>();

                        if (env.IsDevelopment())
                        {
                            app.UseDeveloperExceptionPage();
                        }

                        app.UseRouting();

                        app.UseEndpoints(endpoints =>
                        {
                            endpoints.MapGet("/healthCheck", async context =>
                            {
                                await context.Response.WriteAsync("Red Rival is up and running, publishing healthCheck with 200 Status at 8080");
                            });

                            endpoints.MapGet("/helloWorld", async context =>
                            {
                                await context.Response.WriteAsync("Red Rival says Hello World");
                            });

                            endpoints.MapControllers(); // Map controller routes if any
                        });

                        logger.LogInformation("Application started. Listening on port 8080.");
                    });

                    // Ensure the application listens on port 8080
                    webBuilder.UseUrls("http://*:8080");
                });
    }
}
