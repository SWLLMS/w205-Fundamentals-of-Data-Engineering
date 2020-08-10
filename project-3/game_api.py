#!/usr/bin/env python
import json
from kafka import KafkaProducer
from flask import Flask, request

app = Flask(__name__)
producer = KafkaProducer(bootstrap_servers='kafka:29092')


def log_to_kafka(topic, event):
    event.update(request.headers)
    producer.send(topic, json.dumps(event).encode())


@app.route("/")
def default_response():
    default_event = {'event_type': 'default'}
    log_to_kafka('events', default_event)
    return "This is the default response!\n"


@app.route("/join_a_guild")     #player inputs "join_a_guild"
def join_a_guild():
    join_guild_event = {'event_type': 'join_a_guild', 'description': 'a guild with considerable power'}
    log_to_kafka('events', join_guild_event)     #event logged into kafa as"join_guild
    return "Joined A Guild!\n"     #player displayed upon successful event, "Joined A Guild!"


@app.route("/purchase_a_sword")
def purchase_a_sword():
    purchase_sword_event = {'event_type': 'purchase_sword', 'description': 'a very pointy sword'}
    log_to_kafka('events', purchase_sword_event)
    return "Sword Purchased!\n"


@app.route("/purchase_a_knife")
def purchase_a_knife():
    purchase_knife_event = {'event_type': 'purchase_knife', 'description': 'a very sharp knife'}
    log_to_kafka('events', purchase_knife_event)
    return "Knife Purchased!\n"


