using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

builder.Services.AddDbContext<AbInDenUrlaub.Projekt1Context>(options =>
{
    //options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
    options.UseNpgsql("Server=h2956807.stratoserver.net; Database=Projekt1;Port=5432;SslMode=Disable;User Id=postgres");
});

builder.Services.AddControllers().AddJsonOptions(x =>
    x.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles);

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//var devCorsPolicy = "devCorsPolicy";
//builder.Services.AddCors(options =>
//{
//    options.AddPolicy(devCorsPolicy, builder =>
//    {
//        builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
//    });
//});

var app = builder.Build();
//app.Urls.Add("http://127.0.0.1:5000");
//app.Urls.Add("http://81.169.152.56:5000");

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}


app.UseHttpsRedirection();

app.UseAuthorization();
//app.UseCors(devCorsPolicy);
app.MapControllers();
app.Run();
