Table Overview:
 - Accounts
 	- Grain: 1 row per unique account 
	- Primary Key: account_id 
	- Role: Core business entity representing a customer.
 	- Relationships:
     	- One account > many subscriptions
     	- One account > many support tickets
     	- One account > zero or more churn events

 - Subscriptions
	- Grain: 1 row per unique subscription 
	- Primary Key: subscription_id
	- Foreign Key: account_id > Accounts
	- Role: Revenue-generating entity tied to a customer.
	- Relationships:
     	- Many subscriptions > one account
     	- One subscription > many feature usage events
     	- *Note: Although a subscription contains a churn_flag, the dataset models detailed churn events separately at the account level rather than linking them directly to a subscription. 

 - Feature Usage
	- Grain: 1 row per unique feature usage event
 	- Primary Key: usage_id 	 
	- Foreign Key: subscription_id > Subscriptions
	- Role: Behavioral telemetry capturing customer engagement with the SaaS platform.
   	- Relationships:
    	- Many usage events > one subscription 

 - Support Tickets
	- Grain: 1 row per unique support ticket
 	- Primary Key: ticket_id  
	- Foreign Key: account_id > Accounts
	- Role: Customer support interactions and service quality metrics.
	- Relationships:
    	- Many support tickets > one account

 - Churn Events
	- Grain: 1 row per unique churn event
 	- Primary Key: churn_event_id
	- Foreign Key: account_id > Accounts
   	- Role: Records churn events associated with an account, including churn timing, reason, financial impact, and reactivation history.
  	- Relationships:
    	- Many churn events → one account

Relationship Summary:
- Parent Table:
	- Accounts
	- Accounts
	- Accounts
	- Subscriptions

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
