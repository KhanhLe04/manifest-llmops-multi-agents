# Manifest for LLMOps Multi-Agents System

This repository contains the **Kubernetes manifests** and **Helm charts** for deploying the Multi-Agent LLMOps system using **GitOps** principles (specifically via ArgoCD). It orchestrates the deployment of the frontend, backend agents, and necessary infrastructure components.

## 🔗 Related Repositories

- **Backend (Core Logic & Agents):** [llmops-multi-agents](https://github.com/KhanhLe04/llmops-multi-agents)
- **Frontend (UI):** [chatbot-frontend](https://github.com/KhanhLe04/chatbot-frontend)

---

## 🏗 System Architecture

The system is designed as a set of microservices running on Kubernetes, interacting via REST APIs and shared infrastructure.

### 1. Applications

| Component              | Description                                                                                                | Docker Image                          | Port   | Ingress Host                  |
| :--------------------- | :--------------------------------------------------------------------------------------------------------- | :------------------------------------ | :----- | :---------------------------- |
| **Chatbot Frontend**   | The User Interface developed in React.                                                                     | `khanhle04/chatbot-frontend:v0.0.3`   | `3000` | `chatbot.khanklee.id.vn`      |
| **Orchestrator Agent** | The main backend service handling user requests, conversation history, and coordinating with other agents. | `khanhle04/orchestrator-agent:v2.0.1` | `7010` | `orchestrator.khanklee.id.vn` |
| **RAG Agent**          | Specialized agent for Retrieval-Augmented Generation, interfacing with the Vector DB.                      | `khanhle04/rag-agent:v2.0.1`          | `7005` | `rag.khanklee.id.vn`          |

### 2. Infrastructure & Dependencies

The deployment encompasses the following infrastructure services:

- **Vector Database:** `Qdrant` (Stores embeddings for the `mental_health_advisor` collection)
- **Database:** `PostgreSQL` (Stores application data in `chatbotdb`)
- **Cache/Queue:** `Redis`
- **Secret Management:** `Sealed Secrets` (Securely manages API Keys and Database credentials)
- **Ingress Controller:** `Nginx`
- **Monitoring:** `Prometheus` & `Grafana`

---

## 🚀 Deployment Strategy

This repository utilizes the **App-of-Apps** pattern with ArgoCD.

### Directory Structure

```plaintext
.
├── apps/                   # ArgoCD Application definitions
│   ├── root-app.yaml       # The entry point Application
│   ├── chatbot-frontend.yaml
│   ├── orchestrator-agent.yaml
│   ├── rag-agent.yaml
│   ├── postgresql.yaml
│   ├── redis.yaml
│   ├── qdrant.yaml
│   └── ... (monitoring & networking configs)
├── charts/                 # Local Helm Charts for custom services
│   ├── chatbot-frontend/
│   ├── orchestrator-agent/
│   └── rag-agent/
└── root-app.yaml           # Bootstrapping manifest
```

### How to Deploy

1.  **Prerequisites:**

    - A Kubernetes Cluster.
    - ArgoCD installed in the `argocd` namespace.
    - `kubectl` configured to point to your cluster.

2.  **Bootstrap the Cluster:**
    Apply the root application to tell ArgoCD to manage the `apps` directory:

    ```bash
    kubectl apply -f root-app.yaml
    ```

3.  **Syncing:**
    - ArgoCD will detect the `root-app`.
    - It will then recursively generate and sync all applications defined in the `apps/` folder.
    - This includes the frontend, backend agents, databases, and secrets.

---

## ⚙️ Configuration Details

### Orchestrator Agent

- **Environment Variables:**
  - `REDIS_HOST`, `REDIS_PORT`: Connection to Redis.
  - `POSTGRES_HOST`, `POSTGRES_DB`, `POSTGRES_USER`: Connection to PostgreSQL.
  - `RAG_AGENT_URL`: URL to communicate with the RAG Agent (`http://rag-agent.rag-agent.svc.cluster.local:7005`).
  - `EMBEDDING_MODEL`: `intfloat/multilingual-e5-base`.
  - `QDRANT_URL`: `qdrant.qdrant.svc.cluster.local`.

### RAG Agent

- **Environment Variables:**
  - `QDRANT_URL`: Connection to Qdrant Vector DB.
  - `GOOGLE_API_KEY`: Injected via Sealed Secrets.
