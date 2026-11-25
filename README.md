# Automated 3-Tier Cloud Architecture with Terraform, AWS, and FastAPI

![Terraform](https://img.shields.io/badge/Terraform-1.7%2B-623CE4?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-VPC%20%7C%20RDS-232F3E?logo=amazon-aws&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.11-3776AB?logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-0.110-009688?logo=fastapi&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)

## 📋 Overview

This repository demonstrates a production-inspired, automated multi-tier cloud infrastructure deployed on **Amazon Web Services (AWS)** using **Infrastructure as Code (Terraform)**, a containerized **Python (FastAPI)** backend, and an automated **CI/CD pipeline (GitHub Actions)**.

The primary goal of this project is to showcase core cloud engineering practices: network isolation, least-privilege security controls, reproducible infrastructure provisioning, container hardening, and automated quality gates.

---

## 🏗️ Cloud Architecture

The infrastructure provisions a custom **VPC (`10.0.0.0/16`)** across two Availability Zones (`eu-central-1a` and `eu-central-1b`) for high availability, strictly separating public-facing components from the database tier.

```mermaid
flowchart TB
    subgraph Internet ["🌐 Public Internet"]
        User(["Client / API Consumer"])
    end

    subgraph AWS ["☁️ AWS Cloud (eu-central-1)"]
        IGW["Internet Gateway"]

        subgraph VPC ["Virtual Private Cloud (10.0.0.0/16)"]
            subgraph PublicTier ["Public Subnets (10.0.1.0/24 & 10.0.2.0/24)"]
                App["🐳 FastAPI Container<br/>(Port 8000 | Non-Root User)"]
            end

            subgraph PrivateTier ["Private Subnets (10.0.10.0/24 & 10.0.11.0/24)"]
                SG["🛡️ Security Group<br/>(Inbound: TCP 5432 from VPC CIDR only)"]
                RDS[("🗄️ AWS RDS PostgreSQL 16<br/>(db.t4g.micro | No Public IP)")]
            end
        end
    end

    User -->|HTTP/HTTPS| IGW
    IGW --> App
    App -->|Internal VPC Traffic| SG
    SG --> RDS
