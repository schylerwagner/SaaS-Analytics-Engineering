Table Overview:
 - Accounts
 	- Grain: 1 row per unique account 
	- Primary Key: account_id 
	- Role: Core business entity representing a customer
 	- Relationships (Cardinality):
     	- One account > many subscriptions
     	- One account > many support tickets
     	- One account > zero or more churn events

 - Subscriptions
	- Grain: 1 row per unique subscription 
	- Primary Key: subscription_id
	- Foreign Key: account_id > Accounts
	- Role: Revenue-generating entity tied to a customer
	- Relationships:
     	- Many subscriptions > one account
     	- One subscription > many feature usage events
     	- One subscription > zero or one churn event 

 - Feature Usage
	- Grain: 1 row per usage event 
	- Foreign Key: subscription_id > Subscriptions
	- Role: Behavioral telemetry capturing product engagement
   	- Relationships:
    	- Many usage events > one subscription 

 - Support Tickets
	- Grain: 1 row per ticket 
	- Foreign Key: account_id > Accounts
	- Role: Customer support interaction data
	- Relationships:
    	- Many tickets > one account

 - Churn Events
	- Grain: 1 row per churn event
 	- Primary key:
	- Foreign Key: subscription_id > Subscriptions
   	- Role: Marks the termination (or churn moment) of a subscription lifecycle
  	- Relationships:
    	- Many churn events → one or many subscriptions

Business Interpretation:
 - What defines an “active customer”
	- Accounts identified as still using the product. Exclusion of logged churn activity. 
   		- accounts.churn_flag = FALSE
    	- subscriptions.end_date = NULL
    	- subscriptions.churn_flag = FALSE
    	- churn_events.churn_date = NULL

 - What churn means in this dataset
  	- Accounts that have canceled their subscription.
    
 - What “engagement” likely represents
  	- Usage metrics related to an accounts feature activity. Such as usage days, usage duration and features used.

Considerations:
 - Can an account have multiple subscriptions at the same time?
  	- Yes

 - Is churn tied to account or subscription level?
  	- Churn is modeled at the subscription level to accurately capture multiple lifecycle events per account.

 - What would define a “power user” using feature usage?
  	- Account with above average feature usage metrics
