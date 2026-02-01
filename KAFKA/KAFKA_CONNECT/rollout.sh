#!/bin/bash
kubectl -n kafka-connect rollout restart deploy kafka-connect
kubectl -n kafka-connect rollout status deploy/kafka-connect