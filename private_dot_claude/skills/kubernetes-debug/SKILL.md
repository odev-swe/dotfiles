---
name: kubernetes-debug
description: This skill should be used when the user asks to "debug kubernetes", "troubleshoot pods", "investigate k8s issues", "why is my pod crashing", "pod not starting", "service not reachable", "deployment failing", or any Kubernetes cluster debugging and diagnostics tasks.
version: 1.0.0
---

# Kubernetes Debug Skill

Provides a systematic approach to diagnosing and resolving common Kubernetes issues.

## When This Skill Applies

- Pod is in CrashLoopBackOff, Pending, OOMKilled, or Error state
- Service is unreachable or returning unexpected responses
- Deployment rollout is stuck or failing
- Node issues affecting workloads
- General "why isn't this working" questions about Kubernetes

## Step 1: Get the Big Picture

Start by scoping the problem before diving into logs.

```bash
# Check overall cluster health
kubectl get nodes
kubectl get pods -A | grep -v Running | grep -v Completed

# Narrow to the namespace in question
kubectl get all -n <namespace>
```

## Step 2: Inspect the Problem Resource

```bash
# Describe gives events, conditions, and resource state
kubectl describe pod <pod-name> -n <namespace>
kubectl describe deployment <deploy-name> -n <namespace>
kubectl describe node <node-name>
```

Key things to look for in `describe` output:
- **Events** section at the bottom — shows scheduling failures, image pull errors, OOM kills
- **Conditions** — Ready, PodScheduled, ContainersReady
- **Limits/Requests** — missing or too-low resource requests cause Pending or OOM

## Step 3: Read the Logs

```bash
# Current logs
kubectl logs <pod-name> -n <namespace>

# Previous container instance (useful for CrashLoopBackOff)
kubectl logs <pod-name> -n <namespace> --previous

# Follow live logs
kubectl logs -f <pod-name> -n <namespace>

# Multi-container pod
kubectl logs <pod-name> -c <container-name> -n <namespace>
```

## Step 4: Common Issues and Fixes

### CrashLoopBackOff
- Always check `--previous` logs first — the crash happened before the restart
- Common causes: bad config/env vars, missing secrets, app startup errors

### Pending Pod
- `describe pod` events will say why: insufficient CPU/memory, no matching node, PVC not bound
- Check node capacity: `kubectl describe nodes | grep -A5 "Allocated resources"`

### ImagePullBackOff / ErrImagePull
- Wrong image name or tag
- Private registry: check `imagePullSecrets` is set and the Secret exists
- `kubectl get secret <name> -n <namespace> -o yaml`

### Service Not Reachable
```bash
# Verify endpoints exist (empty = selector doesn't match any pods)
kubectl get endpoints <service-name> -n <namespace>

# Check pod labels match service selector
kubectl get pods -n <namespace> --show-labels
kubectl get svc <service-name> -n <namespace> -o yaml | grep -A5 selector
```

### OOMKilled
- Pod exceeded its memory limit
- Increase `resources.limits.memory` in the pod spec, or investigate memory leak

## Step 5: Exec Into a Running Pod

When logs aren't enough, get a shell:

```bash
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh

# Check env vars inside the container
kubectl exec <pod-name> -n <namespace> -- env

# Test internal DNS resolution
kubectl exec <pod-name> -n <namespace> -- nslookup <service-name>

# Test connectivity to another service
kubectl exec <pod-name> -n <namespace> -- wget -qO- http://<service>:<port>/health
```

## Step 6: Check Recent Events

```bash
# All events in a namespace sorted by time
kubectl get events -n <namespace> --sort-by='.lastTimestamp'

# Watch events in real time
kubectl get events -n <namespace> -w
```

## Quick Reference: Pod Status Meanings

| Status | Meaning |
|---|---|
| `Pending` | Scheduler can't place it (resources, taints, PVC) |
| `CrashLoopBackOff` | Container keeps crashing; check `--previous` logs |
| `OOMKilled` | Exceeded memory limit |
| `ImagePullBackOff` | Can't pull image (name, tag, or auth) |
| `Terminating` | Stuck deletion; may need `--force --grace-period=0` |
| `ContainerCreating` | Volume mount or init container issue |
