# MySQL Cluster with PHPMyAdmin via Docker Compose

This Docker Compose file sets up a MySQL Cluster along with MySQL Master-Slave, and PHPMyAdmin for management.

Sets up 4 NDB nodes and 2 MySQL Servers. With initial DB and User Setup located in the config folder. Volumes are mounted in the volumes folder.

Run this file by running `docker compose up -d` in the folder.

## Services

### MySQL Cluster Nodes

#### Management1 (ndb_mgm)
- **Image:** mysql/mysql-cluster:latest
- **Container Name:** management1
- **Command:** ndb_mgmd --ndb-nodeid=1 --reload --initial
- **Volumes:**
  - `./volumes/ndb_mgmd:/var/lib/mysql/`
  - `./config/my.cnf:/etc/my.cnf`
  - `./config/mysql-cluster.cnf:/etc/mysql-cluster.cnf`
- **Networks:**
  - `mysql_network`
  - **IPv4 Address:** 174.17.0.2

#### NDB1, NDB2, NDB3, NDB4
- Similar configuration for Nodes 1 through 4, adjusting `--ndb-nodeid`, volumes, and IPv4 Address accordingly.

### MySQL Instances

#### MySQL1 (Master)
- **Image:** mysql/mysql-cluster:latest
- **Container Name:** mysql1
- **Command:** mysqld --ndb-nodeid=6 --ndb-connectstring 174.17.0.2 --default-storage-engine=NDBCLUSTER
- **Volumes:**
  - `./volumes/mysqld1:/var/lib/mysql/`
  - `./config/mysql-cluster.cnf:/etc/mysql-cluster.cnf`
  - `./config/init/users.sql:/docker-entrypoint-initdb.d/users.sql`
  - `./config/init/data.sql:/docker-entrypoint-initdb.d/data.sql`
- **Networks:**
  - `mysql_network`
  - **IPv4 Address:** 174.17.0.10
- **Ports:** 3306:3306
- **Environment:**
  - `MYSQL_ROOT_PASSWORD: root`
  - `SERVICE_NAME: mysql`
  - `MYSQL_TCP_PORT: 3306`

#### MySQL2 (Slave)
- **Image:** mysql/mysql-cluster:latest
- **Container Name:** mysql2
- **Command:** mysqld --ndb-nodeid=7 --ndb-connectstring 174.17.0.2 --default-storage-engine=NDBCLUSTER
- **Volumes:**
  - `./volumes/mysqld2:/var/lib/mysql/`
  - `./config/mysql-cluster.cnf:/etc/mysql-cluster.cnf`
  - `./config/init/users.sql:/docker-entrypoint-initdb.d/users.sql`
- **Networks:**
  - `mysql_network`
  - **IPv4 Address:** 174.17.0.11
- **Ports:** 3307:3306
- **Environment:**
  - `MYSQL_ROOT_PASSWORD: root`
  - `SERVICE_NAME: mysql`
  - `MYSQL_TCP_PORT: 3307`

### Other Services

#### PHPMyAdmin
- **Image:** phpmyadmin/phpmyadmin
- **Container Name:** phpmyadmin
- **Ports:** 8181:80
- **Environment:**
  - `PMA_HOSTS: mysql1, mysql2`
  - `PMA_PORTS: 3306, 3307`
  - `PMA_USER: admin`
  - `PMA_PASSWORD: admin`
- **Links:** mysql1, mysql2
- **Networks:** `mysql_network`

## Network Definitions

### MySQL Network
- **IP Range:** 174.17.0.0/16

## Volumes Definition
- `ndb_mgm`
- `mysqld1`
- `mysqld2`
- `ndb1`
- `ndb2`
- `ndb3`
- `ndb4`
- `init`
