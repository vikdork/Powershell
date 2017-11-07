using System;
using System.Runtime.Serialization.Json;
using System.Threading.Tasks;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Collections.Generic;


namespace WebAPIClient
{
    class Program
    {
        static void Main(string[] args)
        {
            ProcssRepositories().Wait();
        }
        private static async Task ProcssRepositories()
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/vnd.github.v3+json"));
            client.DefaultRequestHeaders.Add("User-Agent", ".NET Foundation Repository Reporter");


            var serializer = new DataContractJsonSerializer(typeof(List<Repo>));
            // var stringTask = client.GetStringAsync("https://api.github.com/orgs/dotnet/repos");
            var streamTask = client.GetStreamAsync("https://api.github.com/orgs/dotnet/repos");
            var repositories = serializer.ReadObject(await streamTask) as List<Repo>;

            //var msg = await stringTask;
            foreach (var item in repositories)
            {
                Console.WriteLine("Name: {0}, Fullname : {1}", item.name, item.full_name);
            }

            
            Console.ReadLine();
        }
    }
}
