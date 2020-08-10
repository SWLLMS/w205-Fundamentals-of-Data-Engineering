# Project 3: Understanding User Behavior


## Files included in Reop

- *game_api.py*: An API server to log events to Kafka
- *writes_stream.py*: Uses Spark streaming to filter event types from Kafka, 
  land them into HDFS/Parquet and available for analysis in Presto
- *apache_bench_data.sh*: To generate streaming data for the pipeline
- *docker-compose.yml*: Spins up a docker cluster that inlucdes includes 
  Zookeeper, Flask, Kafka, Spark, Mids, Cloudera, and Presto
- *Report.ipynb*: Provides a detailed description of commands used to create
  streaming pipline for the game with some basic analysis of the events


## Prompt

- I am a data scientist at a game development company  
- My latest mobile game has three events I am interested in tracking: 
  `purchase a sword`, `join guild` & `purhcase a knife`
- Each has metadata characterstic of such events (i.e., host, user-agent,
  description, etc)


## Tasks

- Instrument your API server to log events to Kafka
- Assemble a data pipeline to catch these events: use Spark streaming to filter
  select event types from Kafka, land them into HDFS/parquet to make them
  available for analysis using Presto
- Use Apache Bench to generate test data for your pipeline
- Produce an analytics report where you provide a description of your pipeline
  and some basic analysis of the events
- Use a notebook to present your queries and findings


## Options

There are plenty of advanced options for this project. I chose to
take my project further than just the basics covered in class by 
adding the following to the project:

- Generate and filter more types of events: I have included a thrid event, 
  where players can purhcase a knife. 

