# Project 2: Tracking User Activity

In this project, I work at an ed tech firm. I have created a service that delivers assessments, and now lots of different customers (e.g., Pearson) want to publish their assessments on it. Through this project, I will get ready for data scientists who work for these customers to run queries on the data.

# Tasks

Prepare the infrastructure to land the data in the form and structure it needs
to be to be queried.  You will need to:

- Publish and consume messages with Kafka
- Use Spark to transform the messages 
- Use Spark to transform the messages so that you can land them in HDFS

# Files Included/Submitted To Repo
Not counting this README file, you will find 3 files:
- One example of my `docker-compose.yml` used for spinning the pipeline
- SWLLMS-history.txt: An unedited and complete history file since the beginning of the class
- SWLLMS-annotations: An annotated history of my CML console, spark history including results that describe my queries and spark SQL to answer business questions. This file is broken up into 3 parts:
  - Part One: Transforming Data
  - Part Two: Sourcing Data
  - Part Three: Querying Data. This section includes Data Analysis along with my sql queries. 

## Data File Used

To get the data, run 
```
curl -L -o assessment-attempts-20180128-121051-nested.json https://goo.gl/ME6hjp`
```

## Data Analysis
The questions I used for my SQL query are as follows: ose your own (1 to 3).These examples are meant to get you started/thinking, they are optional.

1. How many assesstments are in the dataset?
2. How many unique exams were offered?
3. How many people took each of the 103 exams?
4. How many people took Learning Git?
5. What is the least common course taken?

