#!/bin/bash

helm upgrade --install --cleanup-on-fail --namespace jhub  --version 1.2.0 --values config_canvas.yaml --set global.safeToShowValues=true jhub jupyterhub/jupyterhub --timeout 30m
