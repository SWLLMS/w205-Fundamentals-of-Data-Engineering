# Project 1: Query Project

- In the Query Project, you will get practice with SQL while learning about
  Google Cloud Platform (GCP) and BiqQuery. You'll answer business-driven
  questions using public datasets housed in GCP. To give you experience with
  different ways to use those datasets, you will use the web UI (BiqQuery) and
  the command-line tools, and work with them in Jupyter Notebooks.

- Type A to get into insert mode in Vim, Use esc to quit and press :wq to exit out of the vim editor from the command line.

#### Problem Statement

- You're a data scientist at Lyft Bay Wheels (https://www.lyft.com/bikes/bay-wheels), formerly known as Ford GoBike, the
  company running Bay Area Bikeshare. You are trying to increase ridership, and
  you want to offer deals through the mobile app to do so. 
  
- What deals do you offer though? Currently, your company has several options which can change over time.  Please visit the website to see the current offers and other marketing information. Frequent offers include: 
  * Single Ride 
  * Monthly Membership
  * Annual Membership
  * Bike Share for All
  * Access Pass
  * Corporate Membership
  * etc.

- Through this project, you will answer these questions: 

  * What are the 5 most popular trips that you would call "commuter trips"? 
  
  * What are your recommendations for offers (justify based on your findings)?

- Please note that there are no exact answers to the above questions, just like in the proverbial real world.  This is not a simple exercise where each question above will have a simple SQL query. It is an exercise in analytics over inexact and dirty data. 

- You won't find a column in a table labeled "commuter trip".  You will find you need to do quite a bit of data exploration using SQL queries to determine your own definition of a communter trip.  In data exploration process, you will find a lot of dirty data, that you will need to either clean or filter out. You will then write SQL queries to find the communter trips.

- Likewise to make your recommendations, you will need to do data exploration, cleaning or filtering dirty data, etc. to come up with the final queries that will give you the supporting data for your recommendations. You can make any recommendations regarding the offers, including, but not limited to: 
  * market offers differently to generate more revenue 
  * remove offers that are not working 
  * modify exising offers to generate more revenue
  * create new offers for hidden business opportunities you have found
  * etc. 

#### All Work MUST be done in the Google Cloud Platform (GCP) / The Majority of Work MUST be done using BigQuery SQL / Usage of Temporary Tables, Views, Pandas, Data Visualizations

A couple of the goals of w205 are for students to learn how to work in a cloud environment (such as GCP) and how to use SQL against a big data data platform (such as Google BigQuery).  In keeping with these goals, please do all of your work in GCP, and the majority of your analytics work using BigQuery SQL queries.

You can make intermediate temporary tables or views in your own dataset in BigQuery as you like.  Actually, this is a great way to work!  These make data exploration much easier.  It's much easier when you have made temporary tables or views with only clean data, filtered rows, filtered columns, new columns, summary data, etc.  If you use intermediate temporary tables or views, you should include the SQL used to create these, along with a brief note mentioning that you used the temporary table or view.

In the final Jupyter Notebook, the results of your BigQuery SQL will be read into Pandas, where you will use the skills you learned in the Python class to print formatted Pandas tables, simple data visualizations using Seaborn / Matplotlib, etc.  You can use Pandas for simple transformations, but please remember the bulk of work should be done using Google BigQuery SQL.

#### GitHub Procedures

In your Python class you used GitHub, with a single repo for all assignments, where you committed without doing a pull request.  In this class, we will try to mimic the real world more closely, so our procedures will be enhanced. 

Each project, including this one, will have it's own repo.

Important:  In w205, please never merge your assignment branch to the master branch. 

Using the git command line: clone down the repo, leave the master branch untouched, create an assignment branch, and move to that branch:
- Open a linux command line to your virtual machine and be sure you are logged in as jupyter.
- Create a ~/w205 directory if it does not already exist `mkdir ~/w205`
- Change directory into the ~/w205 directory `cd ~/w205`
- Clone down your repo `git clone <https url for your repo>`
- Change directory into the repo `cd <repo name>`
- Create an assignment branch `git branch assignment`
- Checkout the assignment branch `git checkout assignment`

The previous steps only need to be done once.  Once you your clone is on the assignment branch it will remain on that branch unless you checkout another branch.

The project workflow follows this pattern, which may be repeated as many times as needed.  In fact it's best to do this frequently as it saves your work into GitHub in case your virtual machine becomes corrupt:
- Make changes to existing files as needed.
- Add new files as needed
- Stage modified files `git add <filename>`
- Commit staged files `git commit -m "<meaningful comment about your changes>"`
- Push the commit on your assignment branch from your clone to GitHub `git push origin assignment`

Once you are done, go to the GitHub web interface and create a pull request comparing the assignment branch to the master branch.  Add your instructor, and only your instructor, as the reviewer.  The date and time stamp of the pull request is considered the submission time for late penalties. 

If you decide to make more changes after you have created a pull request, you can simply close the pull request (without merge!), make more changes, stage, commit, push, and create a final pull request when you are done.  Note that the last data and time stamp of the last pull request will be considered the submission time for late penalties.

---

## Parts 1, 2, 3

We have broken down this project into 3 parts, about 1 week's work each to help you stay on track.

**You will only turn in the project once  at the end of part 3!**

- In Part 1, we will query using the Google BigQuery GUI interface in the cloud.

- In Part 2, we will query using the Linux command line from our virtual machine in the cloud.

- In Part 3, we will query from a Jupyter Notebook in our virtual machine in the cloud, save the results into Pandas, and present a report enhanced by Pandas output tables and simple data visualizations using Seaborn / Matplotlib.

---

## Part 1 - Querying Data with BigQuery

### SQL Tutorial

Please go through this SQL tutorial to help you learn the basics of SQL to help you complete this project.

SQL tutorial: https://www.w3schools.com/sql/default.asp

### Google Cloud Helpful Links

Read: https://cloud.google.com/docs/overview/

BigQuery: https://cloud.google.com/bigquery/

Public Datasets: Bring up your Google BigQuery console, open the menu for the public datasets, and navigate to the the dataset san_francisco.

- The Bay Bike Share has two datasets: a static one and a dynamic one.  The static one covers an historic period of about 3 years.  The dynamic one updates every 10 minutes or so.  THE STATIC ONE IS THE ONE WE WILL USE IN CLASS AND IN THE PROJECT. The reason is that is much easier to learn SQL against a static target instead of a moving target.

- (USE THESE TABLES!) The static tables we will be using in this class are in the dataset **san_francisco** :

  * bikeshare_stations

  * bikeshare_status

  * bikeshare_trips

- The dynamic tables are found in the dataset **san_francisco_bikeshare**

### Some initial queries

Paste your SQL query and answer the question in a sentence.  Be sure you properly format your queries and results using markdown. 

- What's the size of this dataset? (i.e., how many trips) 
  * Answer: 983,648 
  * SQL query: 
    ```
    #standardSQL
    SELECT count (*) 
    FROM `bigquery-public-data.san_francisco.bikeshare_trips` 
    ```

- What is the earliest start date and time and latest end date and time for a trip?
  * Answer: 08/29/2013 at 12:06:01 UTC and 08/31/2016 at 23:58:59 UTC
  * SQL query: 
    ```
    #standardSQL
    SELECT min(time), max(time) 
    FROM `bigquery-public-data.san_francisco.bikeshare_status`
    ```
  
- How many bikes are there?
  * Answer: 700 
  * SQL query: 
    ```
    #standardSQL
    SELECT count(distinct bike_number) 
    FROM `bigquery-public-data.san_francisco.bikeshare_trips` 
    ```

### Questions of your own
- Make up 3 questions and answer them using the Bay Area Bike Share Trips Data.  These questions MUST be different than any of the questions and queries you ran above.

- Question 1: What is the average duration in minutes of all trips?
  * Answer: 16.98 minutes
  * SQL query: 
    ```
    #standardSQL
    SELECT avg(duration_sec/60) 
    FROM `bigquery-public-data.san_francisco.bikeshare_trips`
    ```
- Question 2: What is the average duration of all trips in minutes by subscriber type?
  * Answer: Customer averages 61.98 minutes, Subscriber averages 9.71 minutes.
  * SQL query: 
    ```
    #standardSQL
    SELECT subscriber_type, avg(duration_sec/60) 
    FROM `bigquery-public-data.san_francisco.bikeshare_trips` 
    GROUP BY subscriber_type
    ```

- Question 3: What is the min and max duration in minutes of trips?
  * Answer: Min duration is 1 minute, max duration is 287,840.0 minutes. These are outliers: 1 min could be testing and the other is an anomaly as the bike was checked out by the company head. 
  * SQL query: 
    ```
    #standardSQL
    SELECT min(duration_sec/60), max(duration_sec/60) 
    FROM `bigquery-public-data.san_francisco.bikeshare_trips`
    ```

### Bonus activity queries (optional - not graded - just this section is optional, all other sections are required)

The bike share dynamic dataset offers multiple tables that can be joined to learn more interesting facts about the bike share business across all regions. These advanced queries are designed to challenge you to explore the other tables, using only the available metadata to create views that give you a broader understanding of the overall volumes across the regions(each region has multiple stations)

We can create a temporary table or view against the dynamic dataset to join to our static dataset.

Here is some SQL to pull the region_id and station_id from the dynamic dataset.  You can save the results of this query to a temporary table or view.  You can then join the static tables to this table or view to find the region:
```sql
#standardSQL
select distinct region_id, station_id
from `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info`
```

- Top 5 popular station pairs in each region

- Top 3 most popular regions(stations belong within 1 region)

- Total trips for each short station name in each region

- What are the top 10 used bikes in each of the top 3 region. these bikes could be in need of more frequent maintenance.

---

## Part 2 - Querying data from the BigQuery CLI 

- Use BQ from the Linux command line:

  * General query structure

    ```
    bq query --use_legacy_sql=false '
        SELECT count(*)
        FROM
           `bigquery-public-data.san_francisco.bikeshare_trips`'
    ```

### Queries

1. Rerun the first 3 queries from Part 1 using bq command line tool (Paste your bq
   queries and results here, using properly formatted markdown):

  * What's the size of this dataset? (i.e., how many trips)
    - BQ Query & Answer:
      ```
      bq query --use_legacy_sql=false '
      SELECT count(*)
      FROM `bigquery-public-data.san_francisco.bikeshare_trips`'

      Results:
      +--------+
      |  f0_   |
      +--------+
      | 983648 |
      +--------+
      ```

  * What is the earliest start time and latest end time for a trip?
    - BQ Query & Answer:
      ```
      bq query --use_legacy_sql=false '
      SELECT min(time), max(time)
      FROM `bigquery-public-data.san_francisco.bikeshare_status`'

      Results:
      +---------------------+---------------------+
      |         f0_         |         f1_         |
      +---------------------+---------------------+
      | 2013-08-29 12:06:01 | 2016-08-31 23:58:59 |
      +---------------------+---------------------+
      ```

  * How many bikes are there?
    - BQ Query & Answer:
      ```
      bq query --use_legacy_sql=false ' 
      SELECT count(distinct bike_number) 
      FROM `bigquery-public-data.san_francisco.bikeshare_trips`'

      Results:
      +-----+
      | f0_ |
      +-----+
      | 700 |
      +-----+
      ```

2. New Query (Run using bq and paste your SQL query and answer the question in a sentence, using properly formatted markdown):

  * How many trips are in the morning vs in the afternoon?
    - Answer: There are 412,339 trips that take place in the morning (12AM - 11:59AM) and 571,309 trips that take place in the evening (12PM - 11:59PM). There are 158,970 more trips in the afternoon than in the morning. 
      ```
      bq query --use_legacy_sql=false ' 
      SELECT count(trip_id)
      FROM `bigquery-public-data.san_francisco.bikeshare_trips`
      WHERE EXTRACT(HOUR FROM start_date) >= 0 AND EXTRACT(HOUR FROM start_date) < 12'

      Morning Results:
      +--------+
      |  f0_   |
      +--------+
      | 412339 |
      +--------+

      bq query --use_legacy_sql=false '
      SELECT count(trip_id)
      FROM `bigquery-public-data.san_francisco.bikeshare_trips`
      WHERE EXTRACT(HOUR FROM start_date) >= 12 AND EXTRACT(HOUR FROM start_date) < 24'

      Afternoon Results:
      +--------+
      |  f0_   |
      +--------+
      | 571309 |
      +--------+
      ```


### Project Questions
Identify the main questions you'll need to answer to make recommendations (list
below, add as many questions as you need).

- Question 1: How many trips happen between morning rush (7-9 AM) hour and evening rush hour (5-7 PM) by subscriber type? 

- Question 2: How many trips are subscriber vs customers?

- Question 3: What is the average number of bikes per station in the morning vs all day? 

- Question 4: How many trips checked in and out of a different station by subscriber_type?

- Question 5: How does ridership change on a monthly basis?

- Question 6: How does ridership change on a daily basis over the course of a week (7 days)?

### Answers

Answer at least 4 of the questions you identified above You can use either
BigQuery or the bq command line tool.  Paste your questions, queries and
answers below.

- Question 1: How many trips happen between morning rush (7-9 AM) hour and evening rush hour (5-7 PM) by subscriber type? 
  * Answer: There are 281,663 morning rush hour trips and 226,228 evening rush hour trips for those who are subscribers. Customers account for 14,450 morning rush hour trips and 25,714 evening rush hour trips. 
  * SQL query:
    ```
    bq query --use_legacy_sql=false '
    SELECT count(trip_id), subscriber_type
    FROM `bigquery-public-data.san_francisco.bikeshare_trips`
    WHERE EXTRACT(HOUR FROM start_date) >= 7 AND EXTRACT(HOUR FROM start_date) < 10
    GROUP BY 2'

    Morning Results:
    +--------+-----------------+
    |  f0_   | subscriber_type |
    +--------+-----------------+
    | 281663 | Subscriber      |
    |  14450 | Customer        |
    +--------+-----------------+

    bq query --use_legacy_sql=false '
    SELECT count(trip_id), subscriber_type
    FROM `bigquery-public-data.san_francisco.bikeshare_trips`
    WHERE EXTRACT(HOUR FROM start_date) >= 17 AND EXTRACT(HOUR FROM start_date) < 20
    GROUP BY 2'

    Evening Results: 
    +--------+-----------------+
    |  f0_   | subscriber_type |
    +--------+-----------------+
    |  25714 | Customer        |
    | 226228 | Subscriber      |
    +--------+-----------------+
    ```
  
- Question 2: How many trips are subscriber vs customers?
  * Answer: There are 846,839 subscriber and 136,809 customers.
  * SQL query:
    ```
    bq query --use_legacy_sql=false '
    SELECT count(trip_id), subscriber_type
    FROM `bigquery-public-data.san_francisco.bikeshare_trips`
    GROUP BY 2'

    Results:
    +--------+-----------------+
    |  f0_   | subscriber_type |
    +--------+-----------------+
    | 136809 | Customer        |
    | 846839 | Subscriber      |
    +--------+-----------------+
    ```

- Question 3: What is the average number of bikes per station in the morning rush hour vs all day? 
  * Answer: On average the Station, 2nd at Folsom has fewer bikes in the morning than during the rest of the day. Otherwise the top 5 stations that have few bikes on average in the morning rush hour vs all day are the same with roughly about 5 bikes available. 
  * SQL query:
    ```
    bq query --use_legacy_sql=false '
    SELECT stations.name, avg(bikes_available)
    FROM `bigquery-public-data.san_francisco.bikeshare_status` status, 
         `bigquery-public-data.san_francisco.bikeshare_stations` stations
    WHERE stations.station_id = status.station_id
    GROUP BY 1
    ORDER BY 2 ASC'

    Results All Day:
    +-----------------------------------------------+--------------------+
    |                     name                      |        f0_         |
    +-----------------------------------------------+--------------------+
    | Castro Street and El Camino Real              |  4.615104438208627 |
    | Cowper at University                          |  5.100070723398406 |
    | Cyril Magnin St at Ellis St                   |  5.129477821448623 |
    | Santa Clara at Almaden                        |  5.351653291064911 |
    | Commercial at Montgomery                      |  5.527012426928216 |
    | S. Market st at Park Ave                      |  5.728563443264388 |
    | University and Emerson                        | 5.9805090174167415 |
    | Clay at Battery                               |  6.002830859510541 |
    | 2nd at Folsom                                 | 6.0112477063513845 |
    | Broadway St at Battery St                     |   6.01657965163449 |
    | Embarcadero at Vallejo                        |  6.178801318545743 |
    | San Jose City Hall                            |  6.205876902815292 |
    | Mezes Park                                    | 6.3732413257161005 |
    | Santa Clara County Civic Center               |  6.380210748308181 |
    | Franklin at Maple                             |    6.4022203990198 |
    | St James Park                                 | 6.5406659540894365 |
    | Davis at Jackson                              |  6.636869652865461 |
    | Charleston Park/ North Bayshore Area          | 6.7817564409267295 |
    | Stanford in Redwood City                      |  6.787239319114753 |
    | Mountain View City Hall                       | 6.8434614839602546 |
    | SJSU - San Salvador at 9th                    |  7.062868164019294 |
    | San Mateo County Center                       |  7.108827229110239 |
    | 2nd at South Park                             |  7.148739065284169 |
    | Ryland Park                                   |  7.190660161754635 |
    | Post at Kearney                               |  7.211715590630089 |
    | 5th at Howard                                 |  7.246277083118153 |
    | Redwood City Medical Center                   |  7.271412092058413 |
    | San Antonio Shopping Center                   |  7.300359430371104 |
    | Redwood City Public Library                   |  7.317581931803477 |
    | Embarcadero at Sansome                        |   7.35466085148918 |
    | Mechanics Plaza (Market at Battery)           |    7.3600182354917 |
    | San Salvador at 1st                           | 7.3719437648890676 |
    | Park at Olive                                 |  7.405050150776088 |
    | Washington at Kearney                         |  7.449585373657412 |
    | San Pedro Square                              | 7.4790849949794485 |
    | Embarcadero at Folsom                         |  7.545214064370878 |
    | Townsend at 7th                               |  7.578609089399392 |
    | Beale at Market                               |  7.606096318472009 |
    | Middlefield Light Rail Station                |  7.627448629357509 |
    | Adobe on Almaden                              |  7.655209868183927 |
    | Howard at 2nd                                 |  7.692154431977552 |
    | Japantown                                     |  7.751592879442621 |
    | Grant Avenue at Columbus Avenue               |  7.914138256728387 |
    | San Francisco City Hall                       |   7.99882056316348 |
    | Paseo de San Antonio                          |  8.115232258569153 |
    | San Jose Civic Center                         |  8.209531607771089 |
    | Arena Green / SAP Center                      |  8.241890233097973 |
    | Embarcadero at Bryant                         |  8.331310588568634 |
    | Spear at Folsom                               |  8.382503941723517 |
    | South Van Ness at Market                      |  8.448721047809139 |
    | Golden Gate at Polk                           |  8.488464007048002 |
    | Market at 4th                                 |  8.495075647796037 |
    | California Ave Caltrain Station               |  8.498530710177018 |
    | Yerba Buena Center of the Arts (3rd @ Howard) |  8.691949710053093 |
    | Powell at Post (Union Square)                 |  8.705329457115734 |
    | 5th S. at E. San Salvador St                  |  8.940100390407144 |
    | MLK Library                                   |  9.165732557833806 |
    | SJSU 4th at San Carlos                        |  9.331279811387107 |
    | Powell Street BART                            | 10.016656107239346 |
    | Market at 10th                                | 10.059100561940365 |
    | Palo Alto Caltrain Station                    | 10.087565569823447 |
    | San Antonio Caltrain Station                  | 10.241200771737827 |
    | San Francisco Caltrain (Townsend at 4th)      | 10.989174119451379 |
    | Civic Center BART (7th at Market)             |  11.40996770958626 |
    | Temporary Transbay Terminal (Howard at Beale) |  11.52879431331803 |
    | Mountain View Caltrain Station                | 11.552975544323365 |
    | Redwood City Caltrain Station                 | 11.737816021828055 |
    | Steuart at Market                             | 12.161548888301898 |
    | San Francisco Caltrain 2 (330 Townsend)       | 12.529001741476577 |
    | San Jose Diridon Caltrain Station             | 12.680101503571414 |
    | Market at Sansome                             | 12.728522468974392 |
    | Harry Bridges Plaza (Ferry Building)          | 13.335827408621979 |
    | 2nd at Townsend                               |  13.40106129981009 |
    | 5th St at Folsom St                           | 16.644235082996854 |
    +-----------------------------------------------+--------------------+

    bq query --use_legacy_sql=false '
    SELECT stations.name, avg(bikes_available)
    FROM `bigquery-public-data.san_francisco.bikeshare_status` status, 
         `bigquery-public-data.san_francisco.bikeshare_stations` stations
    WHERE stations.station_id = status.station_id AND 
          EXTRACT (HOUR FROM time) >= 7 AND EXTRACT(HOUR FROM time) < 10
    GROUP BY 1
    ORDER BY 2 ASC'

    Results for Morning Rush Hour: 
    +-----------------------------------------------+--------------------+
    |                     name                      |        f0_         |
    +-----------------------------------------------+--------------------+
    | Castro Street and El Camino Real              |  4.446558312410477 |
    | Cyril Magnin St at Ellis St                   |  4.807619047619048 |
    | Cowper at University                          |  5.017775099408693 |
    | Santa Clara at Almaden                        |  5.570235078393809 |
    | 2nd at Folsom                                 | 5.6324413508636155 |
    | Broadway St at Battery St                     |  5.696219654002228 |
    | Commercial at Montgomery                      |  5.881708799472574 |
    | University and Emerson                        |   5.96851886189917 |
    | S. Market st at Park Ave                      | 6.1228571428571446 |
    | San Jose City Hall                            |  6.299719801388607 |
    | Embarcadero at Vallejo                        | 6.3512732554546005 |
    | Mezes Park                                    | 6.3749739012423134 |
    | Franklin at Maple                             |  6.381404133379655 |
    | Clay at Battery                               |  6.384809526752791 |
    | St James Park                                 |  6.424876898036556 |
    | Santa Clara County Civic Center               | 6.4768950365395765 |
    | Davis at Jackson                              |    6.4776665224468 |
    | Mountain View City Hall                       |   6.55392793126894 |
    | Embarcadero at Sansome                        |  6.597863485588311 |
    | Charleston Park/ North Bayshore Area          |  6.667799822815585 |
    | Washington at Kearney                         |  6.750504769557245 |
    | Ryland Park                                   |   6.83028759445884 |
    | 2nd at South Park                             |  6.931227723180259 |
    | Stanford in Redwood City                      |  6.958919605363557 |
    | SJSU - San Salvador at 9th                    |  7.009966623400694 |
    | 5th at Howard                                 |   7.02039165997074 |
    | Townsend at 7th                               |  7.091625976059488 |
    | San Mateo County Center                       |  7.119854413102815 |
    | San Salvador at 1st                           |  7.223010280816698 |
    | Redwood City Public Library                   | 7.2803108079234224 |
    | San Antonio Shopping Center                   |  7.288190959147325 |
    | Redwood City Medical Center                   |  7.335334261764125 |
    | Middlefield Light Rail Station                |  7.368770216535847 |
    | Park at Olive                                 |  7.424480293384423 |
    | Embarcadero at Bryant                         |  7.460581618146966 |
    | Post at Kearney                               | 7.5169303830067715 |
    | San Pedro Square                              |  7.618775367245587 |
    | Grant Avenue at Columbus Avenue               |  7.647915503443127 |
    | Adobe on Almaden                              |  7.649633269464532 |
    | Japantown                                     |  7.670030080145041 |
    | San Francisco City Hall                       | 7.8016012950589895 |
    | Mechanics Plaza (Market at Battery)           |  7.980988730247034 |
    | Paseo de San Antonio                          |  7.987138677709783 |
    | Arena Green / SAP Center                      |  8.069748618328777 |
    | San Jose Civic Center                         |  8.137848445515798 |
    | Embarcadero at Folsom                         |  8.190383305467854 |
    | Golden Gate at Polk                           |  8.351752271462988 |
    | Spear at Folsom                               |  8.353972227372926 |
    | South Van Ness at Market                      |  8.382419597420531 |
    | San Francisco Caltrain (Townsend at 4th)      |  8.399741434369645 |
    | Powell at Post (Union Square)                 |  8.478212497682186 |
    | Howard at 2nd                                 |     8.480765257634 |
    | California Ave Caltrain Station               |  8.507628201166137 |
    | Market at 4th                                 |  8.536657601417474 |
    | Beale at Market                               |   8.58395656921524 |
    | Market at 10th                                |   8.76925335311204 |
    | Yerba Buena Center of the Arts (3rd @ Howard) |   8.81720646105037 |
    | 5th S. at E. San Salvador St                  |  8.885714285714286 |
    | MLK Library                                   |  9.040623647938691 |
    | SJSU 4th at San Carlos                        |  9.279662937552805 |
    | Temporary Transbay Terminal (Howard at Beale) |  9.583792171904621 |
    | Powell Street BART                            |  9.592933892385819 |
    | Palo Alto Caltrain Station                    | 10.106011908440975 |
    | San Antonio Caltrain Station                  |  10.32722974225848 |
    | Civic Center BART (7th at Market)             | 10.791658940602034 |
    | Redwood City Caltrain Station                 |  11.47195749392151 |
    | Harry Bridges Plaza (Ferry Building)          | 11.480185291101785 |
    | Steuart at Market                             | 11.957135793312286 |
    | 5th St at Folsom St                           | 12.079047619047621 |
    | Mountain View Caltrain Station                | 12.195366421492913 |
    | 2nd at Townsend                               |  12.30794548488783 |
    | San Francisco Caltrain 2 (330 Townsend)       | 12.324298988400589 |
    | San Jose Diridon Caltrain Station             | 12.834909450522266 |
    | Market at Sansome                             | 13.277525392999168 |
    +-----------------------------------------------+--------------------+
    ```  
  
- Question 4: How many trips checked in and out of a different station by subscriber_type?
  * Answer: A commuter trip may not be as easily defined by one-way trip. For example University and Emerson has more customer trips than subsriber trips with no major tourist attractions in the area except Stanford. There maybe an opportunity to convert them to subscribers. Note: Stations may not be spelled correctly (Kearny vs. Kearney)
  * SQL query:
    ```
    bq query --use_legacy_sql=false '
    SELECT start_station_name, end_station_name, subscriber_type, count(*) as trip_freq
    FROM `bigquery-public-data.san_francisco.bikeshare_trips`
    WHERE start_station_name = end_station_name
    GROUP BY start_station_name, end_station_name, subscriber_type
    ORDER BY start_station_name DESC LIMIT 25'
    
    Results For Round-Trip Stations: 
    +-----------------------------------------------+-----------------------------------------------+-----------------+-----------+
    |              start_station_name               |               end_station_name                | subscriber_type | trip_freq |
    +-----------------------------------------------+-----------------------------------------------+-----------------+-----------+
    | Yerba Buena Center of the Arts (3rd @ Howard) | Yerba Buena Center of the Arts (3rd @ Howard) | Customer        |       349 |
    | Yerba Buena Center of the Arts (3rd @ Howard) | Yerba Buena Center of the Arts (3rd @ Howard) | Subscriber      |        97 |
    | Washington at Kearny                          | Washington at Kearny                          | Customer        |       274 |
    | Washington at Kearny                          | Washington at Kearny                          | Subscriber      |        40 |
    | Washington at Kearney                         | Washington at Kearney                         | Customer        |        83 |
    | Washington at Kearney                         | Washington at Kearney                         | Subscriber      |         6 |
    | University and Emerson                        | University and Emerson                        | Subscriber      |        71 |
    | University and Emerson                        | University and Emerson                        | Customer        |      1113 |
    | Townsend at 7th                               | Townsend at 7th                               | Subscriber      |       427 |
    | Townsend at 7th                               | Townsend at 7th                               | Customer        |       168 |
    | Temporary Transbay Terminal (Howard at Beale) | Temporary Transbay Terminal (Howard at Beale) | Subscriber      |       232 |
    | Temporary Transbay Terminal (Howard at Beale) | Temporary Transbay Terminal (Howard at Beale) | Customer        |       132 |
    | Steuart at Market                             | Steuart at Market                             | Subscriber      |       281 |
    | Steuart at Market                             | Steuart at Market                             | Customer        |       630 |
    | Stanford in Redwood City                      | Stanford in Redwood City                      | Subscriber      |        36 |
    | Stanford in Redwood City                      | Stanford in Redwood City                      | Customer        |        27 |
    | St James Park                                 | St James Park                                 | Subscriber      |        44 |
    | St James Park                                 | St James Park                                 | Customer        |        57 |
    | Spear at Folsom                               | Spear at Folsom                               | Subscriber      |       219 |
    | Spear at Folsom                               | Spear at Folsom                               | Customer        |       173 |
    | South Van Ness at Market                      | South Van Ness at Market                      | Subscriber      |       185 |
    | South Van Ness at Market                      | South Van Ness at Market                      | Customer        |       319 |
    | Sequoia Hospital                              | Sequoia Hospital                              | Customer        |         2 |
    | Sequoia Hospital                              | Sequoia Hospital                              | Subscriber      |         2 |
    | Santa Clara at Almaden                        | Santa Clara at Almaden                        | Subscriber      |       110 |
    +-----------------------------------------------+-----------------------------------------------+-----------------+-----------+
    
    bq query --use_legacy_sql=false '
    SELECT start_station_name, end_station_name, subscriber_type, count(*) as trip_freq
    FROM `bigquery-public-data.san_francisco.bikeshare_trips`
    WHERE start_station_name <> end_station_name
    GROUP BY start_station_name, end_station_name, subscriber_type
    ORDER BY trip_freq DESC LIMIT 25'
    
    Results For One-Way Trip Stations:
    +-----------------------------------------------+-----------------------------------------------+-----------------+-----------+
    |              start_station_name               |               end_station_name                | subscriber_type | trip_freq |
    +-----------------------------------------------+-----------------------------------------------+-----------------+-----------+
    | San Francisco Caltrain 2 (330 Townsend)       | Townsend at 7th                               | Subscriber      |      8305 |
    | 2nd at Townsend                               | Harry Bridges Plaza (Ferry Building)          | Subscriber      |      6931 |
    | Townsend at 7th                               | San Francisco Caltrain 2 (330 Townsend)       | Subscriber      |      6641 |
    | Harry Bridges Plaza (Ferry Building)          | 2nd at Townsend                               | Subscriber      |      6332 |
    | Embarcadero at Sansome                        | Steuart at Market                             | Subscriber      |      6200 |
    | Embarcadero at Folsom                         | San Francisco Caltrain (Townsend at 4th)      | Subscriber      |      6158 |
    | Steuart at Market                             | 2nd at Townsend                               | Subscriber      |      5758 |
    | San Francisco Caltrain (Townsend at 4th)      | Harry Bridges Plaza (Ferry Building)          | Subscriber      |      5709 |
    | Temporary Transbay Terminal (Howard at Beale) | San Francisco Caltrain (Townsend at 4th)      | Subscriber      |      5699 |
    | Steuart at Market                             | San Francisco Caltrain (Townsend at 4th)      | Subscriber      |      5695 |
    | Harry Bridges Plaza (Ferry Building)          | Embarcadero at Sansome                        | Subscriber      |      5483 |
    | 2nd at South Park                             | Market at Sansome                             | Subscriber      |      5205 |
    | Townsend at 7th                               | San Francisco Caltrain (Townsend at 4th)      | Subscriber      |      5174 |
    | San Francisco Caltrain (Townsend at 4th)      | Temporary Transbay Terminal (Howard at Beale) | Subscriber      |      5089 |
    | Market at 10th                                | San Francisco Caltrain 2 (330 Townsend)       | Subscriber      |      5008 |
    | Harry Bridges Plaza (Ferry Building)          | San Francisco Caltrain (Townsend at 4th)      | Subscriber      |      4980 |
    | Market at Sansome                             | 2nd at South Park                             | Subscriber      |      4919 |
    | San Francisco Caltrain (Townsend at 4th)      | Embarcadero at Folsom                         | Subscriber      |      4367 |
    | San Francisco Caltrain 2 (330 Townsend)       | Powell Street BART                            | Subscriber      |      4352 |
    | San Francisco Caltrain 2 (330 Townsend)       | 5th at Howard                                 | Subscriber      |      4298 |
    | Powell Street BART                            | San Francisco Caltrain 2 (330 Townsend)       | Subscriber      |      4281 |
    | Steuart at Market                             | Embarcadero at Sansome                        | Subscriber      |      4263 |
    | San Francisco Caltrain (Townsend at 4th)      | Steuart at Market                             | Subscriber      |      4182 |
    | Howard at 2nd                                 | San Francisco Caltrain (Townsend at 4th)      | Subscriber      |      4172 |
    | 2nd at Townsend                               | Steuart at Market                             | Subscriber      |      4079 |
    +-----------------------------------------------+-----------------------------------------------+-----------------+-----------+  
  ```
  
  
- Question 5: How does ridership change on a monthly basis?
  * Answer: Peak ridership among subscribers is June (79,525), August (80,033), and October (80,340). Peak ridership for customers are August (15,543) and September (17,310).
  * SQL query:
    ```
    bq query --use_legacy_sql=false '
    SELECT EXTRACT(MONTH FROM start_date), count(*) as trip_freq
    FROM `bigquery-public-data.san_francisco.bikeshare_trips`
    WHERE subscriber_type = "Subscriber"
    GROUP BY 1
    ORDER by 1'
    
    Results Subscriber:
    +-----+-----------+
    | f0_ | trip_freq |
    +-----+-----------+
    |   1 |     64075 |
    |   2 |     62123 |
    |   3 |     71619 |
    |   4 |     74218 |
    |   5 |     73623 |
    |   6 |     79525 |
    |   7 |     76387 |
    |   8 |     80033 |
    |   9 |     70011 |
    |  10 |     80340 |
    |  11 |     63720 |
    |  12 |     51165 |
    +-----+-----------+
    
    bq query --use_legacy_sql=false '
    SELECT EXTRACT(MONTH FROM start_date), count(*) as trip_freq
    FROM `bigquery-public-data.san_francisco.bikeshare_trips`
    WHERE subscriber_type = "Customer"
    GROUP BY 1
    ORDER by 1'
  
    Results Customer:
    +-----+-----------+
    | f0_ | trip_freq |
    +-----+-----------+
    |   1 |      7713 |
    |   2 |      7862 |
    |   3 |     10158 |
    |   4 |      9978 |
    |   5 |     12741 |
    |   6 |     12147 |
    |   7 |     13152 |
    |   8 |     15543 |
    |   9 |     17310 |
    |  10 |     14038 |
    |  11 |      9371 |
    |  12 |      6796 |
    +-----+-----------+
    ```


---

## Part 3 - Employ notebooks to synthesize query project results

### Get Going

Create a Jupyter Notebook against a Python 3 kernel named Project_1.ipynb in the assignment branch of your repo.

#### Run queries in the notebook 

At the end of this document is an example Jupyter Notebook you can take a look at and run.  

You can run queries using the "bang" command to shell out, such as this:

```
! bq query --use_legacy_sql=FALSE '<your-query-here>'
```

- NOTE: 
- Queries that return over 16K rows will not run this way, 
- Run groupbys etc in the bq web interface and save that as a table in BQ. 
- Max rows is defaulted to 100, use the command line parameter `--max_rows=1000000` to make it larger
- Query those tables the same way as in `example.ipynb`

Or you can use the magic commands, such as this:

```sql
%%bigquery my_panda_data_frame

select start_station_name, end_station_name
from `bigquery-public-data.san_francisco.bikeshare_trips`
where start_station_name <> end_station_name
limit 10
```

```python
my_panda_data_frame
```

#### Report in the form of the Jupter Notebook named Project_1.ipynb

- Using markdown cells, MUST definitively state and answer the two project questions:

  * What are the 5 most popular trips that you would call "commuter trips"? 
  
  * What are your recommendations for offers (justify based on your findings)?

- For any temporary tables (or views) that you created, include the SQL in markdown cells

- Use code cells for SQL you ran to load into Pandas, either using the !bq or the magic commands

- Use code cells to create Pandas formatted output tables (at least 3) to present or support your findings

- Use code cells to create simple data visualizations using Seaborn / Matplotlib (at least 2) to present or support your findings

### Resource: see example .ipynb file 

[Example Notebook](example.ipynb)

