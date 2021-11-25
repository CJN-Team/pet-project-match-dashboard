#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Pet.Project.Match.Dashboard.Api/Pet.Project.Match.Dashboard.Api.csproj", "Pet.Project.Match.Dashboard.Api/"]
COPY ["Pet.Project.Match.Dashboard.Domain/Pet.Project.Match.Dashboard.Domain.csproj", "Pet.Project.Match.Dashboard.Domain/"]
COPY ["Pet.Project.Match.Dashboard.Infraestructure/Pet.Project.Match.Dashboard.Infraestructure.csproj", "Pet.Project.Match.Dashboard.Infraestructure/"]
RUN dotnet restore "Pet.Project.Match.Dashboard.Api/Pet.Project.Match.Dashboard.Api.csproj"
COPY . .
WORKDIR "/src/Pet.Project.Match.Dashboard.Api"
RUN dotnet build "Pet.Project.Match.Dashboard.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Pet.Project.Match.Dashboard.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pet.Project.Match.Dashboard.Api.dll"]