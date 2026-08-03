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
	- Grain: One row per source record in feature_usage.csv
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

Relationship Summary: (Parent Table > Child Table > Cardinality)
- Accounts > Subscriptions > 1 to Many
- Accounts > Support Tickets > 1 to Many
- Accounts > Churn Events > 1 to Zero or Many
- Subscriptions > Feature Usage > 1 to Many

Business Interpretation:
- What defines an “active customer”
	- An active customer is an account with at least one active subscription.
 	- Based on the dataset, an active subscription would generally have: 
   		- subscriptions.end_date IS NULL
    	- subscriptions.churn_flag = FALSE
     - The accounts.churn_flag provides an account-level indicator that the account has experienced churn at some point, but subscription records provide the current subscription lifecycle status.

- What does churn represent?
	- Within this dataset, churn is modeled as an account-level business event.
 	- Each row in churn_events records a churn occurrence for an account and includes additional business context such as:
		- churn date
		- churn reason
		- refund amount
		- preceding upgrade/downgrade activity
		- reactivation indicator
		- customer feedback
	- Because each event has a unique churn_event_id and includes an is_reactivation flag, the dataset supports multiple churn/reactivation cycles for a single account.
    
- What does engagement represent?
	- Engagement represents how customers interact with the SaaS platform through subscription activity.
	- Behavior is measured using feature-level telemetry such as:
		- feature usage frequency
		- usage duration
		- feature adoption
		- beta feature participation
		- application errors
	- These metrics can later be aggregated to evaluate product adoption, customer health, and potential churn risk.

Modeling Considerations
- During initial modeling, one observation was that churn could also reasonably be represented at the subscription level, since subscriptions already contain lifecycle attributes such as start_date, end_date, and churn_flag.
- However, the synthetic dataset intentionally models detailed churn history at the account level, as documented by the source schema. This project preserves the dataset's intended relational design to maintain referential integrity while recognizing that production SaaS platforms may implement subscription-level churn models depending on business requirements.
