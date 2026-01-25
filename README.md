A cross-platform mobile app and .NET API for collaborative group shopping, allowing users to create, share, and manage categorized shopping lists.

backend server setup:
~/ShoppingList/backend/ShoppingList.API % dotnet run  

frontend server setup:
 ~/ShoppingList/frontend % flutter run -d web-server

 SQL Server (Docker)
 docker run -e 'ACCEPT_EULA=Y' \
  -e 'SA_PASSWORD=StrongPass123!' \
  -p 1433:1433 \
  -d mcr.microsoft.com/mssql/server:2022-latest


Sprawdź czy działa:
  docker ps

wejscie do db
docker exec -it <CONTAINER_NAME> /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'StrongPass123!' -C


USE ShoppingListDb;
GO

SELECT * FROM Users;
GO