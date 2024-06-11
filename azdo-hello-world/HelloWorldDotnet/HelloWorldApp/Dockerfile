# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory
WORKDIR /app

# Copy the csproj file and restore any dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code
COPY . ./

# Build the application
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Set the working directory
WORKDIR /app

# Copy the build output to the runtime image
COPY --from=build /app/out .

# Expose port 8080
EXPOSE 8080

# Set the entry point for the container
ENTRYPOINT ["dotnet", "HelloWorldApp.dll"]

