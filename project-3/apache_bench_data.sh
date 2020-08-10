#!/bin/sh

while true 
        do 
        docker-compose exec mids ab -n 3 -H "Host: user1.comcast.com" http://localhost:5000/purchase_a_sword
        docker-compose exec mids ab -n 4 -H "Host: user1.comcast.com" http://localhost:5000/join_a_guild
        docker-compose exec mids ab -n 1 -H "Host: user1.comcast.com" http://localhost:5000/purchase_a_knife
        docker-compose exec mids ab -n 3 -H "Host: user2.att.com" http://localhost:5000/purchase_a_sword
        docker-compose exec mids ab -n 2 -H "Host: user2.att.com" http://localhost:5000/join_a_guild
        docker-compose exec mids ab -n 1 -H "Host: user2.att.com" http://localhost:5000/purchase_a_knife
        docker-compose exec mids ab -n 3 -H "Host: user2.comcast.com" http://localhost:5000/purchase_a_sword
        docker-compose exec mids ab -n 1 -H "Host: user2.comcast.com" http://localhost:5000/join_a_guild
        docker-compose exec mids ab -n 2 -H "Host: user3.comcast.com" http://localhost:5000/purchase_a_knife
        docker-compose exec mids ab -n 1 -H "Host: user3.att.com" http://localhost:5000/purchase_a_sword
        docker-compose exec mids ab -n 3 -H "Host: user3.att.com" http://localhost:5000/join_a_guild
        docker-compose exec mids ab -n 1 -H "Host: user3.att.com" http://localhost:5000/purchase_a_knife
        sleep 10
done