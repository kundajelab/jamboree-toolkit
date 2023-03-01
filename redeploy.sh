#!/bin/bash
helm upgrade --cleanup-on-fail --namespace jhub  --version 1.2.0 --values config.yaml --set global.safeToShowValues=true jhub jupyterhub/jupyterhub --timeout 30m
