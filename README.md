# Salesforce REST API Framework

[![Salesforce CI (Ant migration tool)](https://github.com/lciesielski/REST-API-Framework/actions/workflows/ant.yml/badge.svg)](https://github.com/lciesielski/REST-API-Framework/actions/workflows/ant.yml)

## Use Case

Basically, almost every client is running multiple apps\CRM Instances\environments, thus sooner or later you will have to implement some form of integration.
In Salesforce there are two types of API, standard one provided natively by SF, and custom one that you have to implement from scratch.
While standard version is quite powerful, it might be the case when you will find its capabilities to simply be not enough.
I found out that while Salesforce trigger handlers do get much love in the terms of open source examples, REST integration frameworks are a little behind, so I decided to throw my two cents.

## Information About Implementation

The solution provides a sample base to work with and extend upon. It will recognize integration based on `context` parameter and run specified integration logic. This guarantees separation of logic, e.g. between integration that will expose PII data and integration that will expose only employee information. This can be even further "locked up" by checking for specific integration user and\or sending secret key. 

Depending on integration count switch statement can be replaced with something more dynamic. For example, you  could create an Integration Executor class that implements an interface with a common method that will be dynamically initialized and run based on integration enum. For similar dynamic solution, you can check [Dynamic Campaign Membership Resolver](https://github.com/lciesielski/DynamicCampaignMembershipResolver) (especially `CampaignMembershipUtils` class).

This was built and is validated using standard Salesforce Developer Org.

### Prerequisites

* Salesforce developer sandbox or production
* Tool for deployment (_ant_ or _sfdx_)

### Installation

Run deployment target with your deployment tool with files specified in package.xml

### Usage

For manual REST tests I generally use the excellent [Workbench](https://workbench.developerforce.com/restExplorer.php). 
In input field you will have to supply proper endpoint and parameters e.g.

```
/services/apexrest/v1/users?context=internal
```

or

```
/services/apexrest/v1/users?context=external
```