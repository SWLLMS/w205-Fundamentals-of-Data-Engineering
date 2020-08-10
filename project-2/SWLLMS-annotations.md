# Project 2 - SWLLMS

Created a directory titled Project-2-SWLLMS for all documents pertaining to this project. 
```
cd w205
mkdir Project-2-SWLLMS
cd Project-2-SWLLMS
```



## Part One: Transforming Data with Kafaka

Publish and consume messages with Kafka

### Get the docker-compose.yml file.
```
cp ../course-content/06-Transforming-Data/docker-compose.yml .
```
The docker-compose.yml file created includes Zookeeper, Kafka and mids. 


### Download the JSON file using the curl command.
```
cd w205/Project-2-SWLLMS
curl -L -o assessment-attempts-20180128-121051-nested.json https://goo.gl/ME6hjp
```

### Spin up a docker cluster using docker-compose in detached mode (-d).
```
docker-compse up -d
```

### Create a topic called partone.
```
docker-compose exec kafka kafka-topics --create --topic partone --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181
```

### Check out the data in the JSON file.
```
docker-compose exec mids bash -c "cat /w205/Project-2-SWLLMS/assessment-attempts-20180128-121051-nested.json
 | jq '.[]' -c"
```

### Count how many messages are in the JSON file. 
```
docker-compose exec mids bash -c "cat /w205/ Project-2-SWLLMS/assessment-attempts-20180128-121051-nested.json | jq '. | length'"
```

### Publish the data in the JSON file. 
```
docker-compose exec mids bash -c "cat /w205/Project-2-SWLLMS/assessment-attempts-20180128-121051-nested.json | jq '.[]' -c | kafkacat -P -b kafka:29092 -t partone && echo 'Produced 3280 messages.'"
```

### Consume messages.
```
docker-compose exec mids bash -c "kafkacat -C -b kafka:29092 -t partone -o beginning -e" | wc -l
```

### Take down the cluster.
```
docker-compose down
```



## Part Two: Sourcing Data

Use Spark to transform the messages.
Note: Modified the docker-compose.yml file from part one that had Zookeeper, Kafka and Mids to include Spark.

### Spin up a docker cluster using the modified docker-compose.yml file that includes Spark.
```
docker-compose up -d
```

### Create a topic called parttwo.
```
docker-compose exec kafka kafka-topics --create --topic parttwo --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181
```
### Check the that new topic was created correctly. 
```
docker-compose exec kafka kafka-topics --describe --topic parttwo --zookeeper zookeeper:32181
```

Results:
```
Topic: parttwo  PartitionCount: 1       ReplicationFactor: 1    Configs: 
Topic: parttwo  Partition: 0    Leader: 1       Replicas: 1     Isr: 1
```

### Check data in the JSON file is correct based on information from the last time used.
```
docker-compose exec mids bash -c "cat /w205/ Project-2-SWLLMS/assessment-attempts-20180128-121051-nested.json | jq '. | length'"
```

### Publish the data in the JSON file. 
```
docker-compose exec mids bash -c "cat /w205/Project-2-SWLLMS/assessment-attempts-20180128-121051-nested.json | jq '.[]' -c | kafkacat -P -b kafka:29092 -t parttwo && echo 'Produced 3280 messages.'"
```

### Run Spark using the Spark container.
```
docker-compose exec spark pyspark
```

### Read in data from Kafka into Spark.
```
messages = spark.read.format("kafka").option("kafka.bootstrap.servers", "kafka:29092").option("subscribe","parttwo").option("startingOffsets", "earliest").option("endingOffsets", "latest").load()
```

### Print the schema. 
```
messages.printSchema()
```

Results:
```
root
 |-- key: binary (nullable = true)
 |-- value: binary (nullable = true)
 |-- topic: string (nullable = true)
 |-- partition: integer (nullable = true)
 |-- offset: long (nullable = true)
 |-- timestamp: timestamp (nullable = true)
 |-- timestampType: integer (nullable = true)
 ```
 
### See the data.
```
messages.show()
```

Results:
```
+----+--------------------+-------+---------+------+--------------------+-------------+
| key|               value|  topic|partition|offset|           timestamp|timestampType|
+----+--------------------+-------+---------+------+--------------------+-------------+
|null|[7B 22 6B 65 65 6...|parttwo|        0|     0|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|     1|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|     2|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|     3|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|     4|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|     5|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|     6|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|     7|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|     8|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|     9|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|    10|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|    11|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|    12|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|    13|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|    14|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|    15|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|    16|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|    17|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|    18|1969-12-31 23:59:...|            0|
|null|[7B 22 6B 65 65 6...|parttwo|        0|    19|1969-12-31 23:59:...|            0|
+----+--------------------+-------+---------+------+--------------------+-------------+
only showing top 20 rows
```

### Cast the messages as a string.
```
messages_as_strings=messages.selectExpr("CAST(key AS STRING)", "CAST(value AS STRING)")
```

### Show the messages cast as a string. 
```
messages_as_strings.show()
```

Results:
```
+----+--------------------+
| key|               value|
+----+--------------------+
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
|null|{"keen_timestamp"...|
+----+--------------------+
only showing top 20 rows
```

### Changes to messages_as_strings schema from the original schema.
```
messages_as_strings.printSchema()
```

Results:
```
root
 |-- key: string (nullable = true)
 |-- value: string (nullable = true)
```

### Total count of records in messages_as_strings.
```
messages_as_strings.count()
```

Results: 3280

### Digging into the nested JSON file. 
```
messages_as_strings.select('value').take(1)
```

Results:
```
[Row(value='{"keen_timestamp":"1516717442.735266","max_attempts":"1.0","started_at":"2018-01-23T14:23:19.082Z","base_exam_id":"37f0a30a-7464-11e6-aa92-a8667f27e5dc","user_exam_id":"6d4089e4-bde5-4a22-b65f-18bce9ab79c8","sequences":{"questions":[{"user_incomplete":true,"user_correct":false,"options":[{"checked":true,"at":"2018-01-23T14:23:24.670Z","id":"49c574b4-5c82-4ffd-9bd1-c3358faf850d","submitted":1,"correct":true},{"checked":true,"at":"2018-01-23T14:23:25.914Z","id":"f2528210-35c3-4320-acf3-9056567ea19f","submitted":1,"correct":true},{"checked":false,"correct":true,"id":"d1bf026f-554f-4543-bdd2-54dcf105b826"}],"user_submitted":true,"id":"7a2ed6d3-f492-49b3-b8aa-d080a8aad986","user_result":"missed_some"},{"user_incomplete":false,"user_correct":false,"options":[{"checked":true,"at":"2018-01-23T14:23:30.116Z","id":"a35d0e80-8c49-415d-b8cb-c21a02627e2b","submitted":1},{"checked":false,"correct":true,"id":"bccd6e2e-2cef-4c72-8bfa-317db0ac48bb"},{"checked":true,"at":"2018-01-23T14:23:41.791Z","id":"7e0b639a-2ef8-4604-b7eb-5018bd81a91b","submitted":1,"correct":true}],"user_submitted":true,"id":"bbed4358-999d-4462-9596-bad5173a6ecb","user_result":"incorrect"},{"user_incomplete":false,"user_correct":true,"options":[{"checked":false,"at":"2018-01-23T14:23:52.510Z","id":"a9333679-de9d-41ff-bb3d-b239d6b95732"},{"checked":false,"id":"85795acc-b4b1-4510-bd6e-41648a3553c9"},{"checked":true,"at":"2018-01-23T14:23:54.223Z","id":"c185ecdb-48fb-4edb-ae4e-0204ac7a0909","submitted":1,"correct":true},{"checked":true,"at":"2018-01-23T14:23:53.862Z","id":"77a66c83-d001-45cd-9a5a-6bba8eb7389e","submitted":1,"correct":true}],"user_submitted":true,"id":"e6ad8644-96b1-4617-b37b-a263dded202c","user_result":"correct"},{"user_incomplete":false,"user_correct":true,"options":[{"checked":false,"id":"59b9fc4b-f239-4850-b1f9-912d1fd3ca13"},{"checked":false,"id":"2c29e8e8-d4a8-406e-9cdf-de28ec5890fe"},{"checked":false,"id":"62feee6e-9b76-4123-bd9e-c0b35126b1f1"},{"checked":true,"at":"2018-01-23T14:24:00.807Z","id":"7f13df9c-fcbe-4424-914f-2206f106765c","submitted":1,"correct":true}],"user_submitted":true,"id":"95194331-ac43-454e-83de-ea8913067055","user_result":"correct"}],"attempt":1,"id":"5b28a462-7a3b-42e0-b508-09f3906d1703","counts":{"incomplete":1,"submitted":4,"incorrect":1,"all_correct":false,"correct":2,"total":4,"unanswered":0}},"keen_created_at":"1516717442.735266","certification":"false","keen_id":"5a6745820eb8ab00016be1f1","exam_name":"Normal Forms and All That Jazz Master Class"}')]
```

### Digging deeper into the nested JSON file.
```
messages_as_strings.select('value').take(1)[0].value
```

Results:
```
'{"keen_timestamp":"1516717442.735266","max_attempts":"1.0","started_at":"2018-01-23T14:23:19.082Z","base_exam_id":"37f0a30a-7464-11e6-aa92-a8667f27e5dc","user_exam_id":"6d4089e4-bde5-4a22-b65f-18bce9ab79c8","sequences":{"questions":[{"user_incomplete":true,"user_correct":false,"options":[{"checked":true,"at":"2018-01-23T14:23:24.670Z","id":"49c574b4-5c82-4ffd-9bd1-c3358faf850d","submitted":1,"correct":true},{"checked":true,"at":"2018-01-23T14:23:25.914Z","id":"f2528210-35c3-4320-acf3-9056567ea19f","submitted":1,"correct":true},{"checked":false,"correct":true,"id":"d1bf026f-554f-4543-bdd2-54dcf105b826"}],"user_submitted":true,"id":"7a2ed6d3-f492-49b3-b8aa-d080a8aad986","user_result":"missed_some"},{"user_incomplete":false,"user_correct":false,"options":[{"checked":true,"at":"2018-01-23T14:23:30.116Z","id":"a35d0e80-8c49-415d-b8cb-c21a02627e2b","submitted":1},{"checked":false,"correct":true,"id":"bccd6e2e-2cef-4c72-8bfa-317db0ac48bb"},{"checked":true,"at":"2018-01-23T14:23:41.791Z","id":"7e0b639a-2ef8-4604-b7eb-5018bd81a91b","submitted":1,"correct":true}],"user_submitted":true,"id":"bbed4358-999d-4462-9596-bad5173a6ecb","user_result":"incorrect"},{"user_incomplete":false,"user_correct":true,"options":[{"checked":false,"at":"2018-01-23T14:23:52.510Z","id":"a9333679-de9d-41ff-bb3d-b239d6b95732"},{"checked":false,"id":"85795acc-b4b1-4510-bd6e-41648a3553c9"},{"checked":true,"at":"2018-01-23T14:23:54.223Z","id":"c185ecdb-48fb-4edb-ae4e-0204ac7a0909","submitted":1,"correct":true},{"checked":true,"at":"2018-01-23T14:23:53.862Z","id":"77a66c83-d001-45cd-9a5a-6bba8eb7389e","submitted":1,"correct":true}],"user_submitted":true,"id":"e6ad8644-96b1-4617-b37b-a263dded202c","user_result":"correct"},{"user_incomplete":false,"user_correct":true,"options":[{"checked":false,"id":"59b9fc4b-f239-4850-b1f9-912d1fd3ca13"},{"checked":false,"id":"2c29e8e8-d4a8-406e-9cdf-de28ec5890fe"},{"checked":false,"id":"62feee6e-9b76-4123-bd9e-c0b35126b1f1"},{"checked":true,"at":"2018-01-23T14:24:00.807Z","id":"7f13df9c-fcbe-4424-914f-2206f106765c","submitted":1,"correct":true}],"user_submitted":true,"id":"95194331-ac43-454e-83de-ea8913067055","user_result":"correct"}],"attempt":1,"id":"5b28a462-7a3b-42e0-b508-09f3906d1703","counts":{"incomplete":1,"submitted":4,"incorrect":1,"all_correct":false,"correct":2,"total":4,"unanswered":0}},"keen_created_at":"1516717442.735266","certification":"false","keen_id":"5a6745820eb8ab00016be1f1","exam_name":"Normal Forms and All That Jazz Master Class"}'
```

### Import JSON to make reading the file easier in Spark.
```
import json
```

### Look at first record in the data. 
```
first_message=json.loads(messages_as_strings.select('value').take(1)[0].value)
first_message
```

Results:
```
{'keen_timestamp': '1516717442.735266', 'max_attempts': '1.0', 'started_at': '2018-01-23T14:23:19.082Z', 'base_exam_id': '37f0a30a-7464-11e6-aa92-a8667f27e5dc', 'user_exam_id': '6d4089e4-bde5-4a22-b65f-18bce9ab79c8', 'sequences': {'questions': [{'user_incomplete': True, 'user_correct': False, 'options': [{'checked': True, 'at': '2018-01-23T14:23:24.670Z', 'id': '49c574b4-5c82-4ffd-9bd1-c3358faf850d', 'submitted': 1, 'correct': True}, {'checked': True, 'at': '2018-01-23T14:23:25.914Z', 'id': 'f2528210-35c3-4320-acf3-9056567ea19f', 'submitted': 1, 'correct': True}, {'checked': False, 'correct': True, 'id': 'd1bf026f-554f-4543-bdd2-54dcf105b826'}], 'user_submitted': True, 'id': '7a2ed6d3-f492-49b3-b8aa-d080a8aad986', 'user_result': 'missed_some'}, {'user_incomplete': False, 'user_correct': False, 'options': [{'checked': True, 'at': '2018-01-23T14:23:30.116Z', 'id': 'a35d0e80-8c49-415d-b8cb-c21a02627e2b', 'submitted': 1}, {'checked': False, 'correct': True, 'id': 'bccd6e2e-2cef-4c72-8bfa-317db0ac48bb'}, {'checked': True, 'at': '2018-01-23T14:23:41.791Z', 'id': '7e0b639a-2ef8-4604-b7eb-5018bd81a91b', 'submitted': 1, 'correct': True}], 'user_submitted': True, 'id': 'bbed4358-999d-4462-9596-bad5173a6ecb', 'user_result': 'incorrect'}, {'user_incomplete': False, 'user_correct': True, 'options': [{'checked': False, 'at': '2018-01-23T14:23:52.510Z', 'id': 'a9333679-de9d-41ff-bb3d-b239d6b95732'}, {'checked': False, 'id': '85795acc-b4b1-4510-bd6e-41648a3553c9'}, {'checked': True, 'at': '2018-01-23T14:23:54.223Z', 'id': 'c185ecdb-48fb-4edb-ae4e-0204ac7a0909', 'submitted': 1, 'correct': True}, {'checked': True, 'at': '2018-01-23T14:23:53.862Z', 'id': '77a66c83-d001-45cd-9a5a-6bba8eb7389e', 'submitted': 1, 'correct': True}], 'user_submitted': True, 'id': 'e6ad8644-96b1-4617-b37b-a263dded202c', 'user_result': 'correct'}, {'user_incomplete': False, 'user_correct': True, 'options': [{'checked': False, 'id': '59b9fc4b-f239-4850-b1f9-912d1fd3ca13'}, {'checked': False, 'id': '2c29e8e8-d4a8-406e-9cdf-de28ec5890fe'}, {'checked': False, 'id': '62feee6e-9b76-4123-bd9e-c0b35126b1f1'}, {'checked': True, 'at': '2018-01-23T14:24:00.807Z', 'id': '7f13df9c-fcbe-4424-914f-2206f106765c', 'submitted': 1, 'correct': True}], 'user_submitted': True, 'id': '95194331-ac43-454e-83de-ea8913067055', 'user_result': 'correct'}], 'attempt': 1, 'id': '5b28a462-7a3b-42e0-b508-09f3906d1703', 'counts': {'incomplete': 1, 'submitted': 4, 'incorrect': 1, 'all_correct': False, 'correct': 2, 'total': 4, 'unanswered': 0}}, 'keen_created_at': '1516717442.735266', 'certification': 'false', 'keen_id': '5a6745820eb8ab00016be1f1', 'exam_name': 'Normal Forms and All That Jazz Master Class'}
```

### Explore some of the data in the first record. 
```
print(first_message['keen_timestamp'])
print(first_message['exam_name']) 
```
Results:
1516717442.735266                
Normal Forms and All That Jazz Master Class

### Exit pyspark. 
```
quit()
```

### Close out the cluster.
```
docker-compose down
```



## Part Three - Querying Data

Use Spark to transform the messages so that you can land them in HDFS.
Note: Modified the docker-compose.yml file from part two that had Zookeeper, Kafka, Mids, and Spark to include Cloudera (a distribution of Hadoop). 

### Spin up a docker cluster using docker-compose.
```
docker-compse up -d
```

### Look for exepected files in Hadoop at this stage.
```
docker-compose exec cloudera hadoop fs -ls /tmp/
```

Results:
```
Found 2 items
drwxrwxrwt   - mapred mapred              0 2018-02-06 18:27 /tmp/hadoop-yarn
drwx-wx-wx   - root   supergroup          0 2020-07-11 18:34 /tmp/hive
```

### Create a topic called partthree.
```
docker-compose exec kafka kafka-topics --create --topic partthree --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181
```

### Check the that new topic was created correctly. 
```
docker-compose exec kafka kafka-topics --describe --topic partthree --zookeeper zookeeper:32181
```

Results:
```
Topic: partthree        PartitionCount: 1       ReplicationFactor: 1    Configs: 
Topic: partthree        Partition: 0    Leader: 1       Replicas: 1     Isr: 1
```

### Check that the file is as expected by counting how many messages are in the JSON file. 
```
docker-compose exec mids bash -c "cat /w205/Project-2-SWLLMS/assessment-attempts-20180128-121051-nested.json | jq '. | length'"
```

### Publish the data in the JSON file. 
```
docker-compose exec mids bash -c "cat /w205/Project-2-SWLLMS/assessment-attempts-20180128-121051-nested.json | jq '.[]' -c | kafkacat -P -b kafka:29092 -t partthree && echo 'Produced 3280 messages.'"
```

### Consume messages.
```
docker-compose exec mids bash -c "kafkacat -C -b kafka:29092 -t partone -o beginning -e" | wc -l
```

### Run Spark using the Spark container.
```
docker-compose exec spark pyspark
```

### Read in data from Kafka into Spark.
```
raw_data = spark.read.format("kafka").option("kafka.bootstrap.servers", "kafka:29092").option("subscribe","partthree").option("startingOffsets", "earliest").option("endingOffsets", "latest").load()
```

### Cache the data.
Note: Keeps the data readily available to cut down on processing time. 

```
raw_data.cache()
```

Results:
```
DataFrame[key: binary, value: binary, topic: string, partition: int, offset: bigint, timestamp: timestamp, timestampType: int]
```

### Print the schema. 
```
raw_data.printSchema()
```

Results:
```
root
 |-- key: binary (nullable = true)
 |-- value: binary (nullable = true)
 |-- topic: string (nullable = true)
 |-- partition: integer (nullable = true)
 |-- offset: long (nullable = true)
 |-- timestamp: timestamp (nullable = true)
 |-- timestampType: integer (nullable = true)
 ```
 
### Deal with Unicode and import SYS and JSON. 
```
import sys
import json
sys.stdout = open(sys.stdout.fileno(), mode='w', encoding='utf8', buffering=1)
```
 
### Convert the raw data from binary to strings and show.
```
data_as_strings = raw_data.selectExpr("CAST(value AS STRING)")
data_as_strings.show()
```
 
Results:
```
+--------------------+
|               value|
+--------------------+
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
|{"keen_timestamp"...|
+--------------------+
only showing top 20 rows
```
 
### Unroll the data more.
```
from pyspark.sql import Row
extracted_data = data_as_strings.rdd.map(lambda x: Row(**json.loads(x.value))).toDF()
```
 
 
### Confirm the new schema has expanded.
```
extracted_data.printSchema()
```
 
Results:
```
root
 |-- base_exam_id: string (nullable = true)
 |-- certification: string (nullable = true)
 |-- exam_name: string (nullable = true)
 |-- keen_created_at: string (nullable = true)
 |-- keen_id: string (nullable = true)
 |-- keen_timestamp: string (nullable = true)
 |-- max_attempts: string (nullable = true)
 |-- sequences: map (nullable = true)
 |    |-- key: string
 |    |-- value: array (valueContainsNull = true)
 |    |    |-- element: map (containsNull = true)
 |    |    |    |-- key: string
 |    |    |    |-- value: boolean (valueContainsNull = true)
 |-- started_at: string (nullable = true)
 |-- user_exam_id: string (nullable = true)
 ```
 
### Look at the partially unrolled data. 
```
extracted_data.show()
```
 
Results:
```
+--------------------+-------------+--------------------+------------------+--------------------+------------------+------------+--------------------+--------------------+--------------------+
|        base_exam_id|certification|           exam_name|   keen_created_at|             keen_id|    keen_timestamp|max_attempts|           sequences|          started_at|        user_exam_id|
+--------------------+-------------+--------------------+------------------+--------------------+------------------+------------+--------------------+--------------------+--------------------+
|37f0a30a-7464-11e...|        false|Normal Forms and ...| 1516717442.735266|5a6745820eb8ab000...| 1516717442.735266|         1.0|Map(questions -> ...|2018-01-23T14:23:...|6d4089e4-bde5-4a2...|
|37f0a30a-7464-11e...|        false|Normal Forms and ...| 1516717377.639827|5a674541ab6b0a000...| 1516717377.639827|         1.0|Map(questions -> ...|2018-01-23T14:21:...|2fec1534-b41f-441...|
|4beeac16-bb83-4d5...|        false|The Principles of...| 1516738973.653394|5a67999d3ed3e3000...| 1516738973.653394|         1.0|Map(questions -> ...|2018-01-23T20:22:...|8edbc8a8-4d26-429...|
|4beeac16-bb83-4d5...|        false|The Principles of...|1516738921.1137421|5a6799694fc7c7000...|1516738921.1137421|         1.0|Map(questions -> ...|2018-01-23T20:21:...|c0ee680e-8892-4e6...|
|6442707e-7488-11e...|        false|Introduction to B...| 1516737000.212122|5a6791e824fccd000...| 1516737000.212122|         1.0|Map(questions -> ...|2018-01-23T19:48:...|e4525b79-7904-405...|
|8b4488de-43a5-4ff...|        false|        Learning Git| 1516740790.309757|5a67a0b6852c2a000...| 1516740790.309757|         1.0|Map(questions -> ...|2018-01-23T20:51:...|3186dafa-7acf-47e...|
|e1f07fac-5566-4fd...|        false|Git Fundamentals ...|1516746279.3801291|5a67b627cc80e6000...|1516746279.3801291|         1.0|Map(questions -> ...|2018-01-23T22:24:...|48d88326-36a3-4cb...|
|7e2e0b53-a7ba-458...|        false|Introduction to P...| 1516743820.305464|5a67ac8cb0a5f4000...| 1516743820.305464|         1.0|Map(questions -> ...|2018-01-23T21:43:...|bb152d6b-cada-41e...|
|1a233da8-e6e5-48a...|        false|Intermediate Pyth...|  1516743098.56811|5a67a9ba060087000...|  1516743098.56811|         1.0|Map(questions -> ...|2018-01-23T21:31:...|70073d6f-ced5-4d0...|
|7e2e0b53-a7ba-458...|        false|Introduction to P...| 1516743764.813107|5a67ac54411aed000...| 1516743764.813107|         1.0|Map(questions -> ...|2018-01-23T21:42:...|9eb6d4d6-fd1f-4f3...|
|4cdf9b5f-fdb7-4a4...|        false|A Practical Intro...|1516744091.3127241|5a67ad9b2ff312000...|1516744091.3127241|         1.0|Map(questions -> ...|2018-01-23T21:45:...|093f1337-7090-457...|
|e1f07fac-5566-4fd...|        false|Git Fundamentals ...|1516746256.5878439|5a67b610baff90000...|1516746256.5878439|         1.0|Map(questions -> ...|2018-01-23T22:24:...|0f576abb-958a-4c0...|
|87b4b3f9-3a86-435...|        false|Introduction to M...|  1516743832.99235|5a67ac9837b82b000...|  1516743832.99235|         1.0|Map(questions -> ...|2018-01-23T21:40:...|0c18f48c-0018-450...|
|a7a65ec6-77dc-480...|        false|   Python Epiphanies|1516743332.7596769|5a67aaa4f21cc2000...|1516743332.7596769|         1.0|Map(questions -> ...|2018-01-23T21:34:...|b38ac9d8-eef9-495...|
|7e2e0b53-a7ba-458...|        false|Introduction to P...| 1516743750.097306|5a67ac46f7bce8000...| 1516743750.097306|         1.0|Map(questions -> ...|2018-01-23T21:41:...|bbc9865f-88ef-42e...|
|e5602ceb-6f0d-11e...|        false|Python Data Struc...|1516744410.4791961|5a67aedaf34e85000...|1516744410.4791961|         1.0|Map(questions -> ...|2018-01-23T21:51:...|8a0266df-02d7-44e...|
|e5602ceb-6f0d-11e...|        false|Python Data Struc...|1516744446.3999851|5a67aefef5e149000...|1516744446.3999851|         1.0|Map(questions -> ...|2018-01-23T21:53:...|95d4edb1-533f-445...|
|f432e2e3-7e3a-4a7...|        false|Working with Algo...| 1516744255.840405|5a67ae3f0c5f48000...| 1516744255.840405|         1.0|Map(questions -> ...|2018-01-23T21:50:...|f9bc1eff-7e54-42a...|
|76a682de-6f0c-11e...|        false|Learning iPython ...| 1516744023.652257|5a67ad579d5057000...| 1516744023.652257|         1.0|Map(questions -> ...|2018-01-23T21:46:...|dc4b35a7-399a-4bd...|
|a7a65ec6-77dc-480...|        false|   Python Epiphanies|1516743398.6451161|5a67aae6753fd6000...|1516743398.6451161|         1.0|Map(questions -> ...|2018-01-23T21:35:...|d0f8249a-597e-4e1...|
+--------------------+-------------+--------------------+------------------+--------------------+------------------+------------+--------------------+--------------------+--------------------+
only showing top 20 rows
```

### Further unroll the JSON files nested keys and look at the schema.
```
df_data = spark.read.json(data_as_strings.rdd.map(lambda x: x.value))
df_data.printSchema()
```

Results:
```
root
 |-- base_exam_id: string (nullable = true)
 |-- certification: string (nullable = true)
 |-- exam_name: string (nullable = true)
 |-- keen_created_at: string (nullable = true)
 |-- keen_id: string (nullable = true)
 |-- keen_timestamp: string (nullable = true)
 |-- max_attempts: string (nullable = true)
 |-- sequences: struct (nullable = true)
 |    |-- attempt: long (nullable = true)
 |    |-- counts: struct (nullable = true)
 |    |    |-- all_correct: boolean (nullable = true)
 |    |    |-- correct: long (nullable = true)
 |    |    |-- incomplete: long (nullable = true)
 |    |    |-- incorrect: long (nullable = true)
 |    |    |-- submitted: long (nullable = true)
 |    |    |-- total: long (nullable = true)
 |    |    |-- unanswered: long (nullable = true)
 |    |-- id: string (nullable = true)
 |    |-- questions: array (nullable = true)
 |    |    |-- element: struct (containsNull = true)
 |    |    |    |-- id: string (nullable = true)
 |    |    |    |-- options: array (nullable = true)
 |    |    |    |    |-- element: struct (containsNull = true)
 |    |    |    |    |    |-- at: string (nullable = true)
 |    |    |    |    |    |-- checked: boolean (nullable = true)
 |    |    |    |    |    |-- correct: boolean (nullable = true)
 |    |    |    |    |    |-- id: string (nullable = true)
 |    |    |    |    |    |-- submitted: long (nullable = true)
 |    |    |    |-- user_correct: boolean (nullable = true)
 |    |    |    |-- user_incomplete: boolean (nullable = true)
 |    |    |    |-- user_result: string (nullable = true)
 |    |    |    |-- user_submitted: boolean (nullable = true)
 |-- started_at: string (nullable = true)
 |-- user_exam_id: string (nullable = true)
```
 
### Save to HFS in parquet format.
```
df_data.write.parquet('/tmp/df_data') 
```
 
### From another CLI window, check Hadoop tmp folder contains the df_data.
```
docker-compose exec cloudera hadoop fs -ls /tmp/
```
 
Results:
```
drwxr-xr-x   - root   supergroup          0 2020-07-11 21:25 /tmp/df_data
drwxrwxrwt   - mapred mapred              0 2018-02-06 18:27 /tmp/hadoop-yarn
drwx-wx-wx   - root   supergroup          0 2020-07-11 18:34 /tmp/hive
```
 
### Create table to explore data using spark.sql commands. 
```
df_data.registerTempTable('exams')
```
 
## Data Analysis:
General Project Questions from Project 2 description. 
 
### How many assesstments are in the dataset?
```
spark.sql("SELECT COUNT(user_exam_id) FROM exams").show()
```
 
Results:
```
+-------------------+
|count(user_exam_id)|
+-------------------+
|               3280|
+-------------------+
```
### How many unique exams were offered? 
```
spark.sql("SELECT COUNT(DISTINCT exams.exam_name) FROM exams").show()
```

Results:
```
+-------------------------+                                                     
|count(DISTINCT exam_name)|
+-------------------------+
|                      103|
+-------------------------+
```
### How many people took each of the 103 exams? 
```
spark.sql("SELECT exam_name, COUNT(exam_name) as exam_count FROM exams GROUP BY exam_name ORDER BY exam_count DESC").show()
```

Results:
```
+--------------------+----------+                                               
|           exam_name|exam_count|
+--------------------+----------+
|        Learning Git|       394|
|Introduction to P...|       162|
|Introduction to J...|       158|
|Intermediate Pyth...|       158|
|Learning to Progr...|       128|
|Introduction to M...|       119|
|Software Architec...|       109|
|Beginning C# Prog...|        95|
|    Learning Eclipse|        85|
|Learning Apache M...|        80|
|Beginning Program...|        79|
|       Mastering Git|        77|
|Introduction to B...|        75|
|Advanced Machine ...|        67|
|Learning Linux Sy...|        59|
|JavaScript: The G...|        58|
|        Learning SQL|        57|
|Practical Java Pr...|        53|
|    HTML5 The Basics|        52|
|   Python Epiphanies|        51|
+--------------------+----------+
only showing top 20 rows
```

### How many people took Learning Git?
394 students took Learning Git. It was also the most popular course offered. 

### What is the least common course taken?
```
spark.sql("SELECT exam_name, COUNT(exam_name) as exam_count FROM exams GROUP BY exam_name ORDER BY exam_count ASC").show()
```

Results:
Learning to Visualization
```
+--------------------+----------+                                               
|           exam_name|exam_count|
+--------------------+----------+
|Learning to Visua...|         1|
|Native Web Apps f...|         1|
|Nulls, Three-valu...|         1|
|Operating Red Hat...|         1|
|The Closed World ...|         2|
|Client-Side Data ...|         2|
|Arduino Prototypi...|         2|
|Understanding the...|         2|
|Hibernate and JPA...|         2|
|What's New in Jav...|         2|
|Learning Spring P...|         2|
| Mastering Web Views|         3|
|Using Web Components|         3|
|Service Based Arc...|         3|
|Getting Ready for...|         3|
|Building Web Serv...|         3|
|       View Updating|         4|
|Using Storytellin...|         4|
|An Introduction t...|         5|
|Example Exam For ...|         5|
+--------------------+----------+
```

### Exit pyspark. 
```
quit()
```

### Close out the cluster.
```
docker-compose down
```
