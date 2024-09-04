#Base Image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
#EXPOSE 80
 
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY . .
RUN ls
RUN dotnet restore "./hello-world-api/hello-world-api.csproj"
RUN dotnet build "hello-world-api/hello-world-api.csproj" -c Release -o /app/build
 
FROM build AS publish
RUN dotnet publish "hello-world-api/hello-world-api.csproj" -c Release -o /app/publish
 
#Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
 
# Select non-root port
ENV ASPNETCORE_URLS=http://+:8080
 
# Do not run as root user
RUN chown -R 1000:1000 /app
USER 1000
 
EXPOSE 8080
ENTRYPOINT ["dotnet", "hello-world-api.dll"]