using backend_api.Services;

var builder = WebApplication.CreateBuilder(args);

// Adiciona serviços do Swagger/OpenAPI
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Adiciona controllers
builder.Services.AddControllers();
builder.Services.AddHttpClient<OpenAiService>();

var app = builder.Build();

// Habilita Swagger em todos os ambientes
app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.MapControllers();

app.Run();