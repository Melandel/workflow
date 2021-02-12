# Docker

## Configure VirtualBox's memory usage to 2048
* Docker Run cmd
	* docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=8characters!' -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-CU8-ubuntu
* Set the server to be open for remote access
	* docker exec -it <container_id|container_name> /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P <your_password>
		* EXEC sp_configure 'remote access', 0 ;  
		* GO  
		* RECONFIGURE ;  
		* GO  
* Connect via sqlcmd
	* sqlcmd -S "192.168.99.100" -U "sa" -P "8characters!"
		* (the server host comes from:
			* docker-machine inspect
		* in Driver.IPAddress)

