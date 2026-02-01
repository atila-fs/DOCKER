#!/bin/bash
kubectl scale statefulset kafka-controller --replicas=0 -n kafka
kubectl delete pvc -l app.kubernetes.io/component=controller-eligible,app.kubernetes.io/instance=kafka -n kafka
kubectl scale statefulset kafka-controller --replicas=3 -n kafka