# -*- coding:utf-8 -*-
import datetime
import os
import sys
import json

# from flask import Flask, Response, request, jsonify
import flask
from flask import request
import time
import pathlib

app = flask.Flask(__name__)

"""
@app.route("/data", methods=["GET"])
def index():
    acc_x = ""
    acc_y = ""
    acc_z = ""
    motion_pose = ""
    # Category = flask.request.args.get("Category")

    current_path = os.path.dirname(os.path.abspath(__file__))
    if (pathlib.Path(current_path + "/saved_data.json")).exists():
        with open(current_path + "/saved_data.json", "r", encoding="utf8") as cf:
            data = json.load(cf)
            acc_x = data.get("Accel_X", "")
            acc_y = data.get("Accel_Y", "")
            acc_z = data.get("Accel_Z", "")
            motion_pose = data.get("Motion_Pose", "")

    return flask.jsonify(
        {"acc_x": acc_x, "acc_y": acc_y, "acc_z": acc_z, "motion_pose": motion_pose}
    )
"""


@app.route("/heartbeat", methods=["POST"])
def send_heartbeat():
    data = request.args.get("data")

    systolic = data[0:3]
    diastolic = data[3:5]

    if (
        int(systolic) >= 91
        and int(systolic) <= 119
        and int(diastolic) >= 61
        and int(diastolic) <= 79
    ):
        result = "normal"
    elif (
        int(systolic) >= 120
        and int(systolic) <= 139
        and int(diastolic) >= 80
        and int(diastolic) <= 89
    ):
        result = "prehypertension"
    elif (
        int(systolic) >= 140
        and int(systolic) <= 159
        and int(diastolic) >= 90
        and int(diastolic) <= 99
    ):
        result = "hypertension"
    else:
        result = "normal"

    timestamp = datetime.datetime.now()
    print(timestamp, ":", systolic, diastolic, result)

    json_object = {}
    try:
        with open("heartbeat.json", "w") as f:
            json_object = {
                "systolic": systolic,
                "diastolic": diastolic,
                "result": result,
            }
            json.dump(json_object, f)
    except Exception as e:
        print("heartbeat.json exception: " + str(e))

    return data


@app.route("/medicine", methods=["POST"])
def send_medicine():
    data = request.args.get("data")

    timestamp = datetime.datetime.now()
    print(timestamp, ":", data)

    json_object = {}
    try:
        with open("medicine.json", "w") as f:
            json_object = {"opened": data}
            json.dump(json_object, f)
    except Exception as e:
        print("medicine.json exception: " + str(e))

    return data


@app.route("/status", methods=["GET"])
def read_status():
    try:
        with open("heartbeat.json") as f:
            heartbeat_json = json.load(f)
    except Exception as e:
        print("heartbeat.json read exception: " + str(e))

    try:
        with open("medicine.json") as f:
            medicine_json = json.load(f)
    except Exception as e:
        print("medicinet.json read exception: " + str(e))

    return {
        "systolic": heartbeat_json["systolic"],
        "diastolic": heartbeat_json["diastolic"],
        "result": heartbeat_json["result"],
        "opened": medicine_json["opened"],
    }


if __name__ == "__main__":
    allowed_external = True

    time_cnt = 2
    while time_cnt > 0:
        print("running...", str(allowed_external))
        time.sleep(1)
        time_cnt -= 1

    if allowed_external:
        app.run(host="0.0.0.0", port=9090, threaded=True, use_reloader=False)
    else:
        app.run(host="127.0.0.1", port=9090, threaded=True, use_reloader=False)
