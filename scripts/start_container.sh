#!/bin/bash

set -e

docker pull harshitf5/simple-python-flask-app

docker run -d -p 5000:5000 harshitf5/simple-python-flask-app 


