# Terraform AWS Secure Landing Zone - Architecture

## Overview

The Terraform AWS Secure Landing Zone provides a comprehensive foundation for AWS account security and compliance. This document outlines the architecture and design decisions.

## System Architecture Diagram

```mermaid
graph TB
    %% User/Developer
    User[👤 Developer/Admin]
    
    %% Terraform Configuration
    TF[📋 Terraform Configuration]
    TF --> |deploys| LandingZone
    
    %% Main Landing Zone Module
    subgraph LandingZone [🏗️ Landing Zone Module]
        VPC[🌐 VPC Network]
        CloudTrail[📊 CloudTrail Logging]
        Config[⚙️ AWS Config]
        GuardDuty[🛡️ GuardDuty]
        SecurityHub[🔒 Security Hub]
        Macie[🔍 Macie]
        IAM[👤 IAM Roles]
        Budget[💰 Budget Alerts]
    end
    
    %% AWS Services
    subgraph AWS [☁️ AWS Services]
        S3[(🗄️ S3 Buckets)]
        KMS[🔑 KMS Keys]
        SNS[📢 SNS Topics]
        CloudWatch[📈 CloudWatch]
    end
    
    %% Resource Protection Strategy
    subgraph Protection [🛡️ Resource Protection]
        PreventDestroy{prevent_destroy?}
        Protected[🔒 Protected Resources]
        Unprotected[🔓 Unprotected Resources]
        
        PreventDestroy -->|true| Protected
        PreventDestroy -->|false| Unprotected
    end
    
    %% Connections
    LandingZone --> AWS
    CloudTrail --> S3
    GuardDuty --> S3
    Config --> SNS
    SecurityHub --> CloudWatch
    
    %% Protection Implementation
    S3 --> Protection
    KMS --> Protection
    
    %% User Interactions
    User --> TF
    User --> |test deployment| TestDeploy[🧪 Test Deployment]
    User --> |production deployment| ProdDeploy[🚀 Production Deployment]
    
    %% Deployment Types
    TestDeploy --> |prevent_destroy=false| LandingZone
    ProdDeploy --> |prevent_destroy=true| LandingZone
    
    %% Styling
    classDef awsService fill:#FF9900,stroke:#232F3E,stroke-width:2px,color:#fff
    classDef terraform fill:#7B42BC,stroke:#000,stroke-width:2px,color:#fff
    classDef protection fill:#FF6B6B,stroke:#000,stroke-width:2px,color:#fff
    classDef user fill:#4ECDC4,stroke:#000,stroke-width:2px,color:#fff
    
    class S3,KMS,SNS,CloudWatch awsService
    class TF,LandingZone terraform
    class Protection,Protected,Unprotected protection
    class User,TestDeploy,ProdDeploy user
```

## Detailed Component Architecture

```mermaid
graph LR
    %% Network Layer
    subgraph Network [🌐 Network Layer]
        VPC[VPC<br/>10.0.0.0/16]
        IGW[Internet Gateway]
        NAT[NAT Gateway]
        
        subgraph Subnets [Subnets]
            Public1[Public Subnet 1<br/>10.0.1.0/24]
            Public2[Public Subnet 2<br/>10.0.2.0/24]
            Private1[Private Subnet 1<br/>10.0.3.0/24]
            Private2[Private Subnet 2<br/>10.0.4.0/24]
        end
    end
    
    %% Security Layer
    subgraph Security [🛡️ Security Layer]
        CT[CloudTrail<br/>API Logging]
        AC[AWS Config<br/>Compliance]
        GD[GuardDuty<br/>Threat Detection]
        SH[Security Hub<br/>Findings]
        MC[Macie<br/>Data Classification]
    end
    
    %% Storage Layer
    subgraph Storage [🗄️ Storage Layer]
        CTBucket[CloudTrail Bucket<br/>Logs Storage]
        GDBucket[GuardDuty Bucket<br/>Findings Storage]
        
        subgraph Protection [🛡️ Protection Strategy]
            Protected[Protected Buckets<br/>prevent_destroy=true]
            Unprotected[Unprotected Buckets<br/>prevent_destroy=false]
        end
    end
    
    %% IAM Layer
    subgraph IAM [👤 IAM Layer]
        ReadOnly[ReadOnlyAdmin Role]
        PowerUser[PowerUserRestrictedIAM Role]
        SecurityAuditor[SecurityAuditor Role]
    end
    
    %% Monitoring Layer
    subgraph Monitoring [📊 Monitoring Layer]
        Budget[Budget Alerts]
        SNS[SNS Notifications]
        CloudWatch[CloudWatch Metrics]
    end
    
    %% Connections
    VPC --> IGW
    VPC --> NAT
    Public1 --> IGW
    Public2 --> IGW
    Private1 --> NAT
    Private2 --> NAT
    
    CT --> CTBucket
    GD --> GDBucket
    AC --> SNS
    SH --> CloudWatch
    Budget --> SNS
    
    CTBucket --> Protection
    GDBucket --> Protection
    
    %% Styling
    classDef network fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef security fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    classDef storage fill:#E8F5E8,stroke:#388E3C,stroke-width:2px
    classDef iam fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    classDef monitoring fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    
    class VPC,IGW,NAT,Public1,Public2,Private1,Private2 network
    class CT,AC,GD,SH,MC security
    class CTBucket,GDBucket,Protected,Unprotected storage
    class ReadOnly,PowerUser,SecurityAuditor iam
    class Budget,SNS,CloudWatch monitoring
```

## Architecture Components

### 1. Networking Layer

```
┌─────────────────────────────────────────────────────────────┐
│                    VPC (10.0.0.0/16)                      │
├─────────────────────────────────────────────────────────────┤
│  Public Subnets (2 AZs)     │  Private Subnets (2 AZs)   │
│  • 10.0.1.0/24 (us-east-1a)│  • 10.0.3.0/24 (us-east-1a)│
│  • 10.0.2.0/24 (us-east-1b)│  • 10.0.4.0/24 (us-east-1b)│
├─────────────────────────────────────────────────────────────┤
│  Internet Gateway           │  NAT Gateway                │
│  • Public Internet Access   │  • Private Subnet Access    │
└─────────────────────────────────────────────────────────────┘
```

### 2. Security & Monitoring Layer

```
┌─────────────────────────────────────────────────────────────┐
│                    Security Services                       │
├─────────────────────────────────────────────────────────────┤
│  CloudTrail                │  AWS Config                  │
│  • API Logging             │  • Compliance Monitoring     │
│  • S3 Storage              │  • Managed Rules             │
│  • KMS Encryption          │  • Configuration History     │
├─────────────────────────────────────────────────────────────┤
│  GuardDuty                 │  Security Hub                │
│  • Threat Detection        │  • Centralized Findings      │
│  • S3 Malware Protection   │  • Compliance Standards      │
│  • EBS Volume Scanning     │  • Automated Response        │
└─────────────────────────────────────────────────────────────┘
```

### 3. Data Protection Layer

```
┌─────────────────────────────────────────────────────────────┐
│                    Data Protection                         │
├─────────────────────────────────────────────────────────────┤
│  Macie                     │  S3 Block Public Access      │
│  • Data Classification     │  • Public Access Blocking    │
│  • PII Detection          │  • Bucket Policies           │
│  • Custom Identifiers     │  • Lifecycle Management      │
└─────────────────────────────────────────────────────────────┘
```

### 4. Resource Protection Layer

```
┌─────────────────────────────────────────────────────────────┐
│                    Resource Protection                     │
├─────────────────────────────────────────────────────────────┤
│  Configurable Protection   │  Dual-Bucket Approach        │
│  • prevent_destroy = true │  • Protected Buckets         │
│  • Production Safety      │  • Unprotected Buckets       │
│  • Test Flexibility       │  • Conditional Creation       │
└─────────────────────────────────────────────────────────────┘
```

**Resource Protection Strategy:**
- **Production Environment**: `prevent_destroy = true` (default)
  - Protects critical resources from accidental deletion
  - S3 buckets with `lifecycle.prevent_destroy = true`
  - KMS keys with deletion protection
- **Test Environment**: `prevent_destroy = false`
  - Allows complete cleanup for testing
  - Enables automated resource destruction
  - Supports CI/CD pipeline testing
- **Dual-Bucket Implementation**:
  - Conditional resource creation using `count` parameter
  - `*_protected` buckets with lifecycle protection
  - `*_unprotected` buckets without protection
  - Local references for consistent resource selection

### 4. Identity & Access Management

```
┌─────────────────────────────────────────────────────────────┐
│                    IAM Framework                           │
├─────────────────────────────────────────────────────────────┤
│  Baseline Roles            │  Permission Boundaries       │
│  • ReadOnlyAdmin           │  • Maximum Permissions       │
│  • PowerUserRestrictedIAM  │  • Policy Enforcement        │
│  • SecurityAuditor         │  • Compliance Controls       │
└─────────────────────────────────────────────────────────────┘
```

### 5. Cost Management

```
┌─────────────────────────────────────────────────────────────┐
│                    Cost Management                         │
├─────────────────────────────────────────────────────────────┤
│  AWS Budgets               │  SNS Notifications           │
│  • Cost Thresholds         │  • Email Alerts              │
│  • Automated Actions       │  • Slack Integration         │
│  • Forecast Monitoring     │  • Escalation Procedures     │
└─────────────────────────────────────────────────────────────┘
```