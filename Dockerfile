#Imagem aspnet 3.1 para Ubuntu 18.04 LTS
FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app

LABEL version="1.0" maintainer="Carlos_Rodrigues"

#Imagem sdk 3.1 para Ubuntu 18.04 LTS
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src

# Copiar projeto e restaurar dependencias
COPY . ./
RUN dotnet restore "POCVariavelAmbiente.sln"

# Build da aplicacao
FROM build AS publish
RUN dotnet publish "POCVariavelAmbiente.sln" -c Release -o /app/publish

ENV ASPNETCORE_ENVIRONMENT=Development
ENV DatabaseConnection:connectionString: "Server=192.168.56.1,1433;Database=Estudo;UID=apiusr;PWD=12345678;"

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "POCVariavelAmbiente.dll"]


