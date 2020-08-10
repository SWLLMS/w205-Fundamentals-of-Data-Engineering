# w205 Project 3: Understanding User Behavior

### Problem Statement:

- You're a data scientist at a game development company
- Your latest mobile game has two events you're interested in tracking: ```buy a sword``` & ```join guild```
- Each has metadata characterstic of such events (i.e., sword type, guild name, etc)


### Tasks:

- Instrument your API server to log events to Kafka
- Assemble a data pipeline to catch these events: use Spark streaming to filter select event types from Kafka, land them into HDFS/parquet to make them available for analysis using Presto
- Use Apache Bench to generate test data for your pipeline
- Produce an analytics report where you provide a description of your pipeline and some basic analysis of the events

Use a notebook to present your queries and findings. Remember that this notebook should be appropriate for presentation to someone else in your business who needs to act on your recommendations.

It's understood that events in this pipeline are generated events which make them hard to connect to actual business decisions. However, we'd like students to demonstrate an ability to plumb this pipeline end-to-end, which includes initially generating test data as well as submitting a notebook-based report of at least simple event analytics.


### Files Used for this project:

- game_api.py
- writes_stream.py
- apache_bench_data.sh
- docker-compose.yml

## Process

### Spin up a docker cluster using docker-compose in detached mode (-d).

This file includes Zookeeper, Flask, Kafka, Spark, Mids, Cloudera, and Presto

```docker-compose up -d```

### Create a topic called events.

Not necessary to create a topic as the broker will do it for you, but opted to create it for this project. 

```docker-compose exec kafka kafka-topics --create --topic events --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181```

Results:
```
Created topic events.
```

### Run Flask 

```docker-compose exec mids env FLASK_APP=/w205/project-3-SWLLMS/game_api.py flask run --host 0.0.0.0```

Results: 
```
* Serving Flask app "game_api"
* Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```

Sample game_api.py Code: 

The source code connects incoming events to kafka. I added a description for all user options: join_a_guild, purchase_sword and purchase_knife. 

```
@app.route("/join_a_guild")     #player inputs "join_a_guild"
def join_a_guild():
    join_guild_event = {'event_type': 'join_a_guild', 'description': 'a guild with considerable power'}
    log_to_kafka('events', join_guild_event)     #event logged into kafa
    return "Joined A Guild!\n"     #player displayed upon successful event, "Joined A Guild!"
```    

### Setup another terminal window to watch Kafka events created in the topic. 

Could run this command twice to automatically create the topic. Also running kafkacat without -e so it will run continuously and show all data coming in from my apache_bench_data.sh file. 

```docker-compose exec mids kafkacat -C -b kafka:29092 -t events -o beginning```

### Run the writes_stream.py file.

```docker-compose exec spark spark-submit /w205/project-3-SWLLMS/writes_stream.py``` 

The file writes_stream.py file uses PySpark to send data stream to kafka, identifies the schema for all stream tables and writes into HDFS and creates a parquet file for purchase_sword, join_a_guild, and purchase_knife. 

Sample Code: 
```
def join_a_guild_event_schema():
    """
    root
    |-- Accept: string (nullable = true)
    |-- Host: string (nullable = true)
    |-- User-Agent: string (nullable = true)
    |-- event_type: string (nullable = true)
    |-- description: string (nullable = true)
    |-- timestamp: string (nullable = true)
    """
...    

@udf('boolean')
def is_join_a_guild(event_as_json):
    """udf for filtering events
    """
    event = json.loads(event_as_json)
    if event['event_type'] == 'join_a_guild':
        return True
    return False
...    

sink_g = join_a_guild \
        .writeStream \
        .format("parquet") \
        .option("checkpointLocation", "/tmp/checkpoints_for_join_a_guild") \
        .option("path", "/tmp/join_a_guild") \
        .trigger(processingTime="120 seconds") \
        .start()
    print("join_a_guild awaiting termination.")
    
spark.steams.awaitAnyTermination()
```

### Check Hadoop to see that it wrote to HDFS
```docker-compose exec cloudera hadoop fs -ls /tmp/```

All files are there as expected based on the writes_stream.py file.  

Results:
```
Found 9 items
drwxrwxrwt   - root   supergroup          0 2020-07-29 01:36 /tmp/checkpoints_for_join_a_guild
drwxrwxrwt   - root   supergroup          0 2020-07-29 01:36 /tmp/checkpoints_for_knife_purchases
drwxrwxrwt   - root   supergroup          0 2020-07-29 01:36 /tmp/checkpoints_for_sword_purchases
drwxrwxrwt   - mapred mapred              0 2016-04-06 02:26 /tmp/hadoop-yarn
drwx-wx-wx   - hive   supergroup          0 2020-07-29 01:02 /tmp/hive
drwxr-xr-x   - root   supergroup          0 2020-07-29 01:36 /tmp/join_a_guild
drwxr-xr-x   - root   supergroup          0 2020-07-29 01:36 /tmp/knife_purchases
drwxrwxrwt   - mapred hadoop              0 2016-04-06 02:28 /tmp/logs
drwxr-xr-x   - root   supergroup          0 2020-07-29 01:36 /tmp/sword_purchases
```

### Run Hive in the Hadoop container. 

```docker-compose exec cloudera hive```


### Set up the Hive Metastore.

Used the following commands to create the tables needed to query in presto. Note that the order of column need to be written in the exact order as listed in the writes_stream.py file. 

For sword_purchases:

```create external table if not exists default.sword_purchases (raw_event string, timestamp string, Accept string, Host string, User_Agent string, event_type string, description string) stored as parquet location '/tmp/sword_purchases'  tblproperties ("parquet.compress"="SNAPPY");```

For join_a_guild:

```create external table if not exists default.join_a_guild (raw_event string, timestamp string, Accept string, Host string, User_Agent string, event_type string, description string) stored as parquet location '/tmp/join_a_guild'  tblproperties ("parquet.compress"="SNAPPY");```

For knife_purchases:

```create external table if not exists default.knife_purchases (raw_event string, timestamp string, Accept string, Host string, User_Agent string, event_type string, description string) stored as parquet location '/tmp/knife_purchases'  tblproperties ("parquet.compress"="SNAPPY");```

### Run and query with Presto.
```docker-compose exec presto presto --server presto:8080 --catalog hive --schema default```


### Show that all three tables created are in Presto.

```presto:default> show tables;```

Results:

```
    Table      
-----------------
 join_a_guild    
 knife_purchases 
 sword_purchases 
 (3 rows)

Query 20200730_143835_00002_h6xqh, FINISHED, 1 node
Splits: 2 total, 0 done (0.00%)
0:00 [0 rows, 0B] [0 rows/s, 0B/s]
```

### Check a single table in Presto to check that our tables are set up with the correct schema. 

```presto:default> describe join_a_guild;```

Results:
```
presto:default> describe join_a_guild;
   Column    |  Type   | Comment 
-------------+---------+---------
 raw_event   | varchar |         
 timestamp   | varchar |         
 accept      | varchar |         
 host        | varchar |         
 user_agent  | varchar |         
 event_type  | varchar |         
 description | varchar |         
 (7 rows)

Query 20200730_210901_00003_tyunt, FINISHED, 1 node
Splits: 2 total, 0 done (0.00%)
0:01 [0 rows, 0B] [0 rows/s, 0B/s]
```

### Run my Apache Bench script to generate data stream. 

```sh apache_bench_data.sh```

Sample Code (Commands from apache_bench_data.sh file): 
```
while true 
        do 
        docker-compose exec mids ab -n 3 -H "Host: user1.comcast.com" http://localhost:5000/purchase_a_sword
        docker-compose exec mids ab -n 4 -H "Host: user1.comcast.com" http://localhost:5000/join_a_guild
        docker-compose exec mids ab -n 1 -H "Host: user1.comcast.com" http://localhost:5000/purchase_a_knife
        sleep 10
done
```
        
Results (from Kafka terminal):

```
{"Host": "0", "Connection": "close", "event_type": "default"}
{"Host": "user1.comcast.com", "User-Agent": "ApacheBench/2.3", "event_type": "purchase_sword", "Accept": "*/*", "description": "a very pointy sword"}
{"Host": "user1.comcast.com", "User-Agent": "ApacheBench/2.3", "event_type": "purchase_sword", "Accept": "*/*", "description": "a very pointy sword"}
{"Host": "user1.comcast.com", "User-Agent": "ApacheBench/2.3", "event_type": "purchase_sword", "Accept": "*/*", "description": "a very pointy sword"}
```

This continues for many rows. 


Resulsts (from Flask terminal):

```
127.0.0.1 - - [31/Jul/2020 17:54:35] "GET /purchase_a_knife HTTP/1.0" 200 -
127.0.0.1 - - [31/Jul/2020 17:54:35] "GET /purchase_a_knife HTTP/1.0" 200 -
127.0.0.1 - - [31/Jul/2020 17:54:36] "GET /purchase_a_sword HTTP/1.0" 200 -
127.0.0.1 - - [31/Jul/2020 17:54:36] "GET /join_a_guild HTTP/1.0" 200 -
127.0.0.1 - - [31/Jul/2020 17:54:36] "GET /join_a_guild HTTP/1.0" 200 -
127.0.0.1 - - [31/Jul/2020 17:54:36] "GET /join_a_guild HTTP/1.0" 200 -
127.0.0.1 - - [31/Jul/2020 17:54:37] "GET /purchase_a_knife HTTP/1.0" 200 -
127.0.0.1 - - [31/Jul/2020 18:04:25] "GET /purchase_a_sword HTTP/1.0" 200 -
127.0.0.1 - - [31/Jul/2020 18:04:25] "GET /purchase_a_sword HTTP/1.0" 200 -
```

This continues for many rows. 

## Analysis of streaming data through Presto. 

### Look at the sword_purchases table. 

```presto:default> select * from sword_purchases;```

Results (abbreviated raw_event column): 

```
raw_event   |        timestamp        |accept|       host        |   user_agent    |   event_type   |   description     
------------+-------------------------+------+-------------------+-----------------+----------------+--------------------
{"Host" ... | 2020-07-31 00:23:53.095 | */*  | user2.att.com     | ApacheBench/2.3 | purchase_sword | a very pointy sword 
{"Host" ... | 2020-07-31 00:23:53.105 | */*  | user2.att.com     | ApacheBench/2.3 | purchase_sword | a very pointy sword 
{"Host" ... | 2020-07-31 00:23:53.113 | */*  | user2.att.com     | ApacheBench/2.3 | purchase_sword | a very pointy sword 
{"Host" ... | 2020-07-31 00:23:53.121 | */*  | user2.att.com     | ApacheBench/2.3 | purchase_sword | a very pointy sword 
{"Host" ... | 2020-07-31 00:23:53.129 | */*  | user2.att.com     | ApacheBench/2.3 | purchase_sword | a very pointy sword 
{"Host" ... | 2020-07-31 00:23:54.939 | */*  | user2.comcast.com | ApacheBench/2.3 | purchase_sword | a very pointy sword 
 
```

### How many users joined a guild? 

```presto:default> select count(*) from join_a_guild;```

Results:

```
 _col0 
-------
    80 
(1 row)

Query 20200731_180636_00007_ybjh8, FINISHED, 1 node
Splits: 16 total, 16 done (100.00%)
0:02 [80 rows, 37.1KB] [35 rows/s, 16.7KB/s]
```


### How many users joined a purchased a knife?

```presto:default> select count(*) from knife_purchases;```

Results:

```
  _col0 
-------
    50 
(1 row)

Query 20200731_181739_00008_ybjh8, FINISHED, 1 node
Splits: 19 total, 8 done (42.11%)
0:01 [20 rows, 21.2KB] [23 rows/s, 24.5KB/s]
```

### How many swords did a certain user purchase? 

```presto:default> select count(*) from sword_purchases where Host = 'user1.comcast.com';```

Results: 

```
 _col0 
-------
    30 
(1 row)

Query 20200731_182021_00010_ybjh8, FINISHED, 1 node
Splits: 19 total, 17 done (89.47%)
0:02 [90 rows, 40.8KB] [43 rows/s, 19.8KB/s]
```

### How many guilds did a certain user join? 

```select count(*) from join_a_guild where Host = 'user2.att.com';```

Results:

```
 _col0 
-------
    20 
(1 row)

Query 20200731_182330_00011_ybjh8, FINISHED, 1 node
Splits: 19 total, 18 done (94.74%)
0:01 [97 rows, 45.7KB] [91 rows/s, 43.2KB/s]
```

### What kind of guilds were joined? 

```presto:default> select distinct description from join_a_guild;```

Results:
```
           description           
---------------------------------
 a guild with considerable power 
(1 row)

Query 20200731_184620_00013_ybjh8, FINISHED, 1 node
Splits: 20 total, 18 done (90.00%)
0:01 [97 rows, 45.7KB] [84 rows/s, 39.6KB/s]
```


```python

```
